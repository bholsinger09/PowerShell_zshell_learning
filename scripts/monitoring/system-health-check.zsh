#!/bin/zsh
#
# Script Name: system-health-check.zsh
# Description: Comprehensive system health and performance check for macOS
# Author: DevOps Automation
# Date: 2024-10-05
# Version: 1.0
#
# Usage: ./system-health-check.zsh [--verbose] [--log]
# Example: ./system-health-check.zsh --verbose --log
#

set -euo pipefail

# ============ Configuration ============
SCRIPT_DIR="${0:a:h}"
LOG_DIR="${HOME}/.logs/zshell-automation"
LOG_FILE="${LOG_DIR}/system-health-check.log"
VERBOSE="${VERBOSE:-false}"
SHOULD_LOG="${SHOULD_LOG:-false}"

# Thresholds for warnings
CPU_THRESHOLD=80
MEMORY_THRESHOLD=85
DISK_THRESHOLD=90

# ============ Functions ============

# Initialize logging
init_logging() {
    mkdir -p "$LOG_DIR"
    touch "$LOG_FILE"
}

# Logging function
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    if [[ "$level" == "INFO" ]]; then
        echo "ℹ️  [$timestamp] $message"
    elif [[ "$level" == "WARN" ]]; then
        echo "⚠️  [$timestamp] WARNING: $message"
    elif [[ "$level" == "ERROR" ]]; then
        echo "❌ [$timestamp] ERROR: $message"
    elif [[ "$level" == "SUCCESS" ]]; then
        echo "✅ [$timestamp] $message"
    fi
    
    if [[ "$SHOULD_LOG" == "true" ]]; then
        echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    fi
}

# Check CPU usage
check_cpu() {
    log "INFO" "Checking CPU usage..."
    
    # Get top CPU processes
    local cpu_usage
    cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')
    
    if (( ${cpu_usage%.*} > CPU_THRESHOLD )); then
        log "WARN" "High CPU usage: ${cpu_usage}%"
    else
        log "SUCCESS" "CPU usage: ${cpu_usage}%"
    fi
}

# Check memory usage
check_memory() {
    log "INFO" "Checking memory usage..."
    
    # Get memory usage
    local mem_stats
    mem_stats=$(vm_stat)
    
    local pages_free
    local pages_inactive
    local pages_active
    
    pages_free=$(echo "$mem_stats" | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
    pages_inactive=$(echo "$mem_stats" | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
    pages_active=$(echo "$mem_stats" | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
    
    # Simple percentage (active / total)
    local total_pages=$((pages_free + pages_inactive + pages_active))
    local mem_percent=$((pages_active * 100 / total_pages))
    
    if (( mem_percent > MEMORY_THRESHOLD )); then
        log "WARN" "High memory usage: ${mem_percent}%"
    else
        log "SUCCESS" "Memory usage: ${mem_percent}%"
    fi
}

# Check disk usage
check_disk() {
    log "INFO" "Checking disk usage..."
    
    # Get disk usage for root volume
    local disk_info
    disk_info=$(df -h / | tail -1)
    
    local used_percent
    used_percent=$(echo "$disk_info" | awk '{print $5}' | sed 's/%//')
    
    if (( used_percent > DISK_THRESHOLD )); then
        log "WARN" "High disk usage: ${used_percent}%"
    else
        log "SUCCESS" "Disk usage: ${used_percent}%"
    fi
    
    if [[ "$VERBOSE" == "true" ]]; then
        echo "  $disk_info"
    fi
}

# Check battery status (if applicable)
check_battery() {
    log "INFO" "Checking battery status..."
    
    local battery_info
    battery_info=$(pmset -g batt)
    
    # Extract percentage
    local battery_percent
    battery_percent=$(echo "$battery_info" | grep -oE "[0-9]+%" | head -1)
    
    log "SUCCESS" "Battery: $battery_percent"
    
    if [[ "$VERBOSE" == "true" ]]; then
        echo "  $battery_info"
    fi
}

# Check network connectivity
check_network() {
    log "INFO" "Checking network connectivity..."
    
    if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
        log "SUCCESS" "Network connectivity: OK"
    else
        log "WARN" "Network connectivity: FAILED"
    fi
}

# Check running processes count
check_processes() {
    log "INFO" "Checking running processes..."
    
    local process_count
    process_count=$(ps aux | wc -l)
    
    log "SUCCESS" "Running processes: $process_count"
    
    if [[ "$VERBOSE" == "true" ]]; then
        echo "  Top 5 CPU-consuming processes:"
        ps aux | sort -k3 -rn | head -6 | tail -5 | awk '{printf "    %s %%CPU - %s\n", $3, $11}'
    fi
}

# Check disk I/O
check_disk_io() {
    log "INFO" "Checking disk I/O..."
    
    # macOS doesn't have iostat by default, use simpler check
    if [[ -d /dev/disk* ]]; then
        log "SUCCESS" "Disk devices: OK"
    else
        log "WARN" "Disk devices: Issue detected"
    fi
}

# Check system uptime
check_uptime() {
    log "INFO" "Checking system uptime..."
    
    local uptime_info
    uptime_info=$(uptime)
    
    log "SUCCESS" "System uptime: $uptime_info"
}

# Print summary
print_summary() {
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║   macOS System Health Check Complete   ║"
    echo "╚════════════════════════════════════════╝"
    
    if [[ "$SHOULD_LOG" == "true" ]]; then
        echo ""
        echo "📝 Log file: $LOG_FILE"
    fi
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --verbose)
                VERBOSE="true"
                ;;
            --log)
                SHOULD_LOG="true"
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --verbose    Show detailed output"
                echo "  --log        Save output to log file"
                echo "  --help       Show this help message"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
        shift
    done
}

# ============ Main Execution ============

main() {
    parse_args "$@"
    init_logging
    
    log "INFO" "Starting system health check..."
    
    check_uptime
    check_cpu
    check_memory
    check_disk
    check_battery
    check_network
    check_processes
    check_disk_io
    
    print_summary
    
    log "INFO" "System health check completed"
}

main "$@"
