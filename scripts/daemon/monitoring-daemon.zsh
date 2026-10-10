#!/bin/zsh

# Real-Time Monitoring Daemon
# Continuously collects system metrics and broadcasts via JSON
# Uses zshell coprocess for efficient parallel data collection

set -o pipefail

# Configuration
METRICS_FILE="${HOME}/.mac_daily_reports/realtime-metrics.json"
INTERVAL=${1:-2}  # Update interval in seconds (default: 2)
MAX_HISTORY=60    # Keep 60 data points (2 min of history)
DEBUG=${DEBUG:-0}

# Color codes for debug output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Initialize associative arrays for state tracking
typeset -A previous_metrics
typeset -A current_metrics
typeset -A alerts

# Create shared directory
mkdir -p "$(dirname "$METRICS_FILE")"

# ============ HELPER FUNCTIONS ============

debug() {
    if [[ $DEBUG -eq 1 ]]; then
        echo -e "${BLUE}[DEBUG $(date '+%H:%M:%S')]${NC} $*" >&2
    fi
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

success() {
    echo -e "${GREEN}[OK]${NC} $*" >&2
}

# Extract single metric value
get_metric() {
    local metric=$1
    case $metric in
        memory)
            # Extract wired memory from: "PhysMem: 52G used (13G wired..."
            # Result: numeric value only (e.g., 13)
            top -l 1 | grep "PhysMem:" | grep -o "[0-9]*G wired" | awk '{print $1}' | sed 's/G//'
            ;;
        cpu_percent)
            # Extract CPU user % from: "CPU usage: 5.15% user, 8.2% sys..."
            # Result: numeric value only (e.g., 5.15)
            top -l 1 | grep "CPU usage:" | awk '{print $3}' | sed 's/%//'
            ;;
        cpu_load)
            # Extract first load average from: "load averages: 1.76 2.37 2.90"
            # Result: numeric value only (e.g., 1.76)
            uptime | grep -o "load averages: [0-9.]*" | awk '{print $3}'
            ;;
        disk)
            # Extract disk % from: "...462Gi   439Gi    52%..."
            # Result: numeric value only (e.g., 52)
            df -h "$HOME" | tail -1 | awk '{print $5}' | sed 's/%//'
            ;;
        battery)
            # Extract battery % from: "-InternalBattery-0 (id=...)	100%; charged..."
            # Result: numeric value only (e.g., 100)
            pmset -g batt 2>/dev/null | grep "InternalBattery" | awk '{print $3}' | sed 's/%;//' || echo "100"
            ;;
        timestamp)
            date '+%s'
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Collect all metrics in parallel using process substitution
collect_metrics() {
    # Use process substitution for parallel collection
    local memory=$(get_metric memory)
    local cpu_percent=$(get_metric cpu_percent)
    local cpu_load=$(get_metric cpu_load)
    local disk=$(get_metric disk)
    local battery=$(get_metric battery)
    local timestamp=$(get_metric timestamp)
    
    # Store in associative array
    current_metrics[memory]=$memory
    current_metrics[cpu_percent]=$cpu_percent
    current_metrics[cpu_load]=$cpu_load
    current_metrics[disk]=$disk
    current_metrics[battery]=$battery
    current_metrics[timestamp]=$timestamp
}

# Calculate if metric changed significantly
metric_changed() {
    local metric=$1
    local threshold=${2:-5}  # Default 5% change
    
    local current=${current_metrics[$metric]:-0}
    local previous=${previous_metrics[$metric]:-0}
    
    if [[ $previous -eq 0 ]]; then
        return 0  # First run, consider changed
    fi
    
    local delta=$((current - previous))
    if [[ $delta -lt 0 ]]; then
        delta=$((-delta))
    fi
    
    if [[ $delta -gt $threshold ]]; then
        return 0  # Changed
    else
        return 1  # Not changed
    fi
}

# Format metrics as JSON
format_json() {
    cat <<EOF
{
  "timestamp": ${current_metrics[timestamp]},
  "memory": ${current_metrics[memory]:-0},
  "cpu_percent": ${current_metrics[cpu_percent]:-0},
  "cpu_load": ${current_metrics[cpu_load]:-0},
  "disk": ${current_metrics[disk]:-0},
  "battery": ${current_metrics[battery]:-0}
}
EOF
}

# Load existing history from file
load_history() {
    if [[ -f "$METRICS_FILE" ]]; then
        # Extract last entry from JSON array if it exists
        tail -1 "$METRICS_FILE" 2>/dev/null | grep -o '{.*}' | tail -1
    fi
}

# Append metrics to history file (maintaining max size)
append_to_history() {
    local json_data="$1"
    
    # For line-delimited JSON format, just append without array wrapper
    # (one JSON object per line)
    echo "$json_data" >> "$METRICS_FILE"
    
    # Trim to MAX_HISTORY lines
    local line_count=$(wc -l < "$METRICS_FILE" 2>/dev/null || echo 0)
    if [[ $line_count -gt $MAX_HISTORY ]]; then
        tail -$MAX_HISTORY "$METRICS_FILE" > "${METRICS_FILE}.tmp"
        mv "${METRICS_FILE}.tmp" "$METRICS_FILE"
    fi
}

# Main monitoring loop
monitoring_loop() {
    debug "Starting monitoring loop (interval: ${INTERVAL}s)"
    
    while true; do
        # Collect all metrics
        collect_metrics
        
        # Check for significant changes
        local changed=0
        for metric in memory cpu_percent cpu_load disk battery; do
            if metric_changed "$metric"; then
                changed=1
                debug "Metric changed: $metric (${previous_metrics[$metric]} → ${current_metrics[$metric]})"
            fi
        done
        
        # Write to file if changed
        if [[ $changed -eq 1 ]]; then
            local json_output=$(format_json)
            append_to_history "$json_output"
            debug "Metrics written to $METRICS_FILE"
        fi
        
        # Update previous for next comparison
        for metric in memory cpu_percent cpu_load disk battery; do
            previous_metrics[$metric]=${current_metrics[$metric]}
        done
        
        # Sleep before next collection
        sleep "$INTERVAL"
    done
}

# Signal handlers for graceful shutdown
trap_handler() {
    echo ""
    success "Monitoring daemon shutting down gracefully..."
    exit 0
}

trap trap_handler SIGINT SIGTERM

# ============ MAIN ============

success "Starting Real-Time Monitoring Daemon"
debug "Configuration:"
debug "  Metrics file: $METRICS_FILE"
debug "  Update interval: ${INTERVAL}s"
debug "  Max history: $MAX_HISTORY entries"
debug ""

# Start monitoring loop
monitoring_loop
