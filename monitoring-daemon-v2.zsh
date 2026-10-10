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

get_network_stats() {
    # Get detailed network statistics: download, upload speeds and active connections
    # Uses netstat -i to get packet counts from all active interfaces
    
    local bytes_in=0
    local bytes_out=0
    
    # Parse netstat -i output for cumulative bytes
    # netstat -i shows Ipkts (incoming packets) and Opkts (outgoing packets)
    # We'll use this as a proxy for bytes (packet count * avg packet size ~500 bytes)
    while IFS= read -r line; do
        # Skip header and loopback
        if [[ $line =~ "^en" ]]; then
            # en0 line format: en0 1500 <Link> ca:e7:14:e6:84:de Ipkts Ierrs Opkts Oerrs
            local ipkts=$(echo "$line" | awk '{print $5}')
            local opkts=$(echo "$line" | awk '{print $7}')
            # Estimate bytes: packets * average packet size (500 bytes)
            bytes_in=$((bytes_in + ipkts * 500))
            bytes_out=$((bytes_out + opkts * 500))
        fi
    done < <(netstat -i)
    
    # Calculate throughput (Mbps) from difference
    local current_time=$(date +%s%N | cut -b1-13)  # milliseconds
    local time_diff_ms=$((current_time - PREV_TIMESTAMP))
    local time_diff_sec=$((time_diff_ms / 1000))
    
    local download_mbps=0
    local upload_mbps=0
    local total_mbps=0
    
    if [[ $PREV_TIMESTAMP -gt 0 && $time_diff_sec -gt 0 ]]; then
        local bytes_diff_in=$((bytes_in - PREV_BYTES_IN))
        local bytes_diff_out=$((bytes_out - PREV_BYTES_OUT))
        
        # Convert bytes to Mbps: (bytes / seconds) * 8 / 1,000,000
        # Simplified: (bytes * 8) / (1000000 * seconds)
        if [[ $bytes_diff_in -gt 0 ]]; then
            download_mbps=$(echo "scale=2; ($bytes_diff_in * 8) / (1000000 * $time_diff_sec)" | bc)
        fi
        if [[ $bytes_diff_out -gt 0 ]]; then
            upload_mbps=$(echo "scale=2; ($bytes_diff_out * 8) / (1000000 * $time_diff_sec)" | bc)
        fi
        total_mbps=$(echo "scale=2; $download_mbps + $upload_mbps" | bc)
    fi
    
    # Get connection statistics
    local connection_count=$(netstat -an 2>/dev/null | grep -c "ESTABLISHED" || echo "0")
    
    PREV_BYTES_IN=$bytes_in
    PREV_BYTES_OUT=$bytes_out
    PREV_TIMESTAMP=$current_time
    
    echo "$download_mbps|$upload_mbps|$total_mbps|$connection_count"
}

get_active_connections() {
    # Get top 5 active connections (IP:port and protocol)
    # Returns: "ip:port:proto|ip:port:proto|..."
    
    netstat -an 2>/dev/null | grep "ESTABLISHED" | awk '{
        # Parse: proto local_ip.port remote_ip.port state
        # Split on space and extract relevant fields
        split($4, local, ".")
        split($5, remote, ".")
        proto = tolower($1)
        if (proto ~ /tcp/) proto = "TCP"
        if (proto ~ /udp/) proto = "UDP"
        # Get last 2 parts of remote IP (significant for tracking)
        n = split($5, parts, ".")
        if (n >= 2) {
            remote_end = parts[n-1] "." parts[n]
            printf "%s:%s|", remote_end, proto
        }
    }' | sed 's/|$//' | cut -d'|' -f1-5
}

get_network_throughput() {
    # Legacy function - delegates to new get_network_stats
    local stats=$(get_network_stats)
    local download=$(echo "$stats" | cut -d'|' -f1)
    local upload=$(echo "$stats" | cut -d'|' -f2)
    echo "$download|$upload"
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
        
        # Enhanced network stats
        local network_stats=$(get_network_stats)
        local network_down=$(echo "$network_stats" | cut -d'|' -f1 | tr -d '\n')
        local network_up=$(echo "$network_stats" | cut -d'|' -f2 | tr -d '\n')
        local network_total=$(echo "$network_stats" | cut -d'|' -f3 | tr -d '\n')
        local connection_count=$(echo "$network_stats" | cut -d'|' -f4 | tr -d '\n')
        
        local active_connections=$(get_active_connections | tr -d '\n')
        local top_processes=$(get_top_processes | tr -d '\n')
        local uptime=$(get_system_info | tr -d '\n')
        
        # Create JSON with enhanced network info (using printf for clean output)
        printf '{\n  "timestamp": %s,\n  "memory": %s,\n  "cpu_percent": %s,\n  "cpu_load": %s,\n  "disk": %s,\n  "battery": %s,\n  "network_down_mbps": %s,\n  "network_up_mbps": %s,\n  "network_total_mbps": %s,\n  "network_connections": "%s",\n  "connection_count": %s,\n  "top_processes": "%s",\n  "uptime_hours": %s\n}\n' \
            "$timestamp" "$memory" "$cpu_percent" "$cpu_load" "$disk" "$battery" \
            "$network_down" "$network_up" "$network_total" "$active_connections" \
            "$connection_count" "$top_processes" "$uptime" >> "$METRICS_FILE"
        
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
