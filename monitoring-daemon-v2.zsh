#!/bin/zsh

# Enhanced Monitoring Daemon for MacBook Pro
# Collects: Memory, CPU, Disk, Battery, Network, and Top Processes
# Writes to: ~/.mac_daily_reports/realtime-metrics.json

# Configuration
REPORT_DIR="$HOME/.mac_daily_reports"
METRICS_FILE="$REPORT_DIR/realtime-metrics.json"
COLLECTION_INTERVAL=3  # seconds

# Ensure report directory exists
mkdir -p "$REPORT_DIR"

# Previous network stats for throughput calculation
declare -g PREV_BYTES_IN=0
declare -g PREV_BYTES_OUT=0
declare -g PREV_TIMESTAMP=0

# ============================================================================
# METRIC EXTRACTION FUNCTIONS
# ============================================================================

get_memory_percent() {
    # Get wired memory percentage (actual in-use, not cache)
    local phys_mem=$(vm_stat | grep "PhysMem:" | awk '{
        gsub(/[MGK,]/, "", $2)
        gsub(/[MGK,]/, "", $5)
        gsub(/[MGK,]/, "", $8)
        # Format: "PhysMem: 52G used (13G wired, ..."
        # We want wired / total * 100
        wired = $5
        used = $2
        # Assume ~64GB total for MacBook Pro
        printf "%.0f\n", (wired / 64) * 100
    }')
    echo "${phys_mem:-0}"
}

get_cpu_percent() {
    # Get user CPU percentage from top output
    local cpu=$(top -l 1 -n 0 | grep "CPU usage:" | awk '{
        # Format: "CPU usage: 3.45% user, 2.15% sys, 94.40% idle"
        gsub(/%/, "", $3)  # Remove % from user value
        printf "%.2f\n", $3
    }')
    echo "${cpu:-0}"
}

get_cpu_load() {
    # Get average load from uptime
    local load=$(uptime | awk '{
        # Get last field (1-minute load average)
        gsub(/,/, "", $(NF-2))  # Remove comma from number
        printf "%.2f\n", $(NF-2)
    }')
    echo "${load:-0}"
}

get_disk_percent() {
    # Get disk usage percentage
    local disk=$(df -h / | tail -1 | awk '{
        gsub(/%/, "", $5)  # Remove % from usage value
        print $5
    }')
    echo "${disk:-0}"
}

get_battery_percent() {
    # Get battery percentage
    local battery=$(pmset -g batt | grep -o "[0-9]*%" | head -1 | sed 's/%//g')
    echo "${battery:-100}"
}

get_network_throughput() {
    # Get network bytes in/out for all active interfaces
    local bytes_in=0
    local bytes_out=0
    
    # Parse ifconfig for bytes
    while IFS= read -r line; do
        if [[ $line =~ "bytes in"([0-9]+)"out"([0-9]+) ]]; then
            bytes_in=$((bytes_in + ${BASH_REMATCH[1]}))
            bytes_out=$((bytes_out + ${BASH_REMATCH[2]}))
        fi
    done < <(ifconfig | grep bytes)
    
    # Calculate throughput (Mbps) from difference
    local current_time=$(date +%s)
    local time_diff=$((current_time - PREV_TIMESTAMP))
    
    local throughput_in=0
    local throughput_out=0
    
    if [[ $PREV_TIMESTAMP -gt 0 && $time_diff -gt 0 ]]; then
        # Convert bytes to Mbps: (bytes_diff / time_diff) / (1024*1024) * 8
        local bytes_diff_in=$((bytes_in - PREV_BYTES_IN))
        local bytes_diff_out=$((bytes_out - PREV_BYTES_OUT))
        throughput_in=$((bytes_diff_in / time_diff / 131072))  # Approximate
        throughput_out=$((bytes_diff_out / time_diff / 131072))
    fi
    
    PREV_BYTES_IN=$bytes_in
    PREV_BYTES_OUT=$bytes_out
    PREV_TIMESTAMP=$current_time
    
    echo "$throughput_in|$throughput_out"
}

get_top_processes() {
    # Get top 5 CPU-using processes
    local processes=$(ps aux | tail -n +2 | sort -rn -k 3,3 | head -5 | awk '{
        # Extract: command, cpu%, memory%
        gsub(/\(.*\)/, "", $11)  # Remove args from command name
        cmd = $11
        if (length(cmd) > 20) cmd = substr(cmd, 1, 20) "..."
        printf "%s:%.1f:%.1f|", cmd, $3, $4
    }')
    echo "${processes%|}"  # Remove trailing |
}

get_system_info() {
    # Get uptime
    local uptime_seconds=$(sysctl -n kern.boottime | awk '{print $4}' | tr -d ',')
    local current_time=$(date +%s)
    local uptime_hours=$(( (current_time - uptime_seconds) / 3600 ))
    echo "$uptime_hours"
}

# ============================================================================
# MAIN COLLECTION LOOP
# ============================================================================

monitoring_loop() {
    while true; do
        # Collect all metrics
        local timestamp=$(date +%s)
        local memory=$(get_memory_percent)
        local cpu_percent=$(get_cpu_percent)
        local cpu_load=$(get_cpu_load)
        local disk=$(get_disk_percent)
        local battery=$(get_battery_percent)
        local network=$(get_network_throughput)
        local network_in=$(echo "$network" | cut -d'|' -f1)
        local network_out=$(echo "$network" | cut -d'|' -f2)
        local top_processes=$(get_top_processes)
        local uptime=$(get_system_info)
        
        # Create JSON
        local json=$(cat <<EOF
{
  "timestamp": $timestamp,
  "memory": $memory,
  "cpu_percent": $cpu_percent,
  "cpu_load": $cpu_load,
  "disk": $disk,
  "battery": $battery,
  "network_in_mbps": $network_in,
  "network_out_mbps": $network_out,
  "top_processes": "$top_processes",
  "uptime_hours": $uptime
}
EOF
        )
        
        # Append to metrics file
        echo "$json" >> "$METRICS_FILE"
        
        # Wait for next collection
        sleep $COLLECTION_INTERVAL
    done
}

# ============================================================================
# STARTUP - Only run if not being sourced
# ============================================================================

# Check if this script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]] || [[ "${0}" == "zsh" ]] || [[ $0 == *"monitoring-daemon-v2.zsh" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting Enhanced Monitoring Daemon"
    echo "  Memory, CPU, Disk, Battery"
    echo "  + Network Throughput (Mbps)"
    echo "  + Top 5 Processes"
    echo "  Writing to: $METRICS_FILE"
    echo ""
    
    # Start monitoring loop
    monitoring_loop
fi
