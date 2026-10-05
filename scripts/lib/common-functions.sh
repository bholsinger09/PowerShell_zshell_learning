# Zshell Common Functions Library
# 
# Source this file in your scripts to use common functions:
# source "${0:a:h}/../lib/common-functions.sh"
#

# ============ Logging Functions ============

# Initialize logging
init_logging() {
    local log_dir="${1:-${HOME}/.logs/zshell-automation}"
    mkdir -p "$log_dir"
    export LOG_DIR="$log_dir"
    export LOG_FILE="${log_dir}/script.log"
}

# Log message with timestamp
log_message() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$level] $message" | tee -a "${LOG_FILE:-/dev/null}"
}

# Convenience logging functions
log_info() {
    log_message "INFO" "$@"
}

log_warn() {
    log_message "WARN" "$@" >&2
}

log_error() {
    log_message "ERROR" "$@" >&2
}

log_success() {
    log_message "SUCCESS" "$@"
}

# ============ Error Handling ============

# Exit with error message
error_exit() {
    echo "❌ ERROR: $*" >&2
    exit 1
}

# Check if command exists
command_exists() {
    command -v "$1" > /dev/null 2>&1
}

# Require command or exit
require_command() {
    local cmd="$1"
    if ! command_exists "$cmd"; then
        error_exit "Required command not found: $cmd"
    fi
}

# ============ File Operations ============

# Check if file exists
file_exists() {
    [[ -f "$1" ]]
}

# Check if directory exists
dir_exists() {
    [[ -d "$1" ]]
}

# Safely create directory
create_dir() {
    local dir="$1"
    if ! mkdir -p "$dir" 2>/dev/null; then
        error_exit "Failed to create directory: $dir"
    fi
}

# Safely copy file with backup
safe_copy() {
    local source="$1"
    local dest="$2"
    
    if ! file_exists "$source"; then
        error_exit "Source file not found: $source"
    fi
    
    if file_exists "$dest"; then
        local backup="${dest}.backup.$(date +%s)"
        log_warn "Backing up existing file to: $backup"
        cp "$dest" "$backup"
    fi
    
    cp "$source" "$dest"
    log_success "Copied $source to $dest"
}

# ============ System Information ============

# Get macOS version
get_macos_version() {
    sw_vers -productVersion
}

# Check if running on Apple Silicon
is_apple_silicon() {
    [[ "$(uname -m)" == "arm64" ]]
}

# Get free disk space in GB
get_free_disk_space() {
    df / | tail -1 | awk '{print $4 / 1048576}' | cut -d. -f1
}

# Get total memory in GB
get_total_memory() {
    sysctl -n hw.memsize | awk '{print $1 / 1073741824}' | cut -d. -f1
}

# Get number of CPU cores
get_cpu_cores() {
    sysctl -n hw.ncpu
}

# ============ Process Management ============

# Check if process is running by name
is_process_running() {
    local process_name="$1"
    pgrep -f "$process_name" > /dev/null 2>&1
}

# Kill process by name gracefully, then force if needed
kill_process_safe() {
    local process_name="$1"
    local timeout="${2:-5}"
    
    if ! is_process_running "$process_name"; then
        log_info "Process not running: $process_name"
        return 0
    fi
    
    log_info "Attempting graceful shutdown of: $process_name"
    pkill -TERM -f "$process_name" 2>/dev/null || true
    
    # Wait for process to terminate
    local elapsed=0
    while is_process_running "$process_name" && [[ $elapsed -lt $timeout ]]; do
        sleep 1
        ((elapsed++))
    done
    
    if is_process_running "$process_name"; then
        log_warn "Forcing termination of: $process_name"
        pkill -9 -f "$process_name" 2>/dev/null || true
    fi
    
    log_success "Process terminated: $process_name"
}

# Wait for process to start
wait_for_process() {
    local process_name="$1"
    local timeout="${2:-30}"
    local elapsed=0
    
    log_info "Waiting for process to start: $process_name"
    
    while ! is_process_running "$process_name" && [[ $elapsed -lt $timeout ]]; do
        sleep 1
        ((elapsed++))
    done
    
    if is_process_running "$process_name"; then
        log_success "Process started: $process_name"
        return 0
    else
        error_exit "Timeout waiting for process: $process_name"
    fi
}

# ============ macOS-Specific Functions ============

# Open application
open_app() {
    local app_name="$1"
    
    if is_process_running "$app_name"; then
        log_warn "Application already running: $app_name"
        return 1
    fi
    
    log_info "Opening application: $app_name"
    open -a "$app_name" 2>/dev/null || error_exit "Failed to open: $app_name"
    
    wait_for_process "$app_name"
}

# Close application gracefully
close_app() {
    local app_name="$1"
    
    if ! is_process_running "$app_name"; then
        log_info "Application not running: $app_name"
        return 0
    fi
    
    log_info "Closing application: $app_name"
    osascript -e "tell application \"$app_name\" to quit" 2>/dev/null || \
        kill_process_safe "$app_name"
}

# Get battery percentage (if available)
get_battery_percentage() {
    local battery_info
    battery_info=$(pmset -g batt 2>/dev/null || echo "")
    
    if [[ -n "$battery_info" ]]; then
        echo "$battery_info" | grep -oE "[0-9]+%" | head -1 | sed 's/%//'
    else
        echo "0"
    fi
}

# Check if connected to power
is_on_power() {
    pmset -g batt | grep -q "AC Power" && return 0 || return 1
}

# ============ Network Functions ============

# Check internet connectivity
has_internet() {
    ping -c 1 8.8.8.8 > /dev/null 2>&1
}

# Get local IP address
get_local_ip() {
    ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1
}

# Get public IP address
get_public_ip() {
    curl -s https://api.ipify.org 2>/dev/null || echo "unknown"
}

# ============ Time/Scheduling Functions ============

# Convert seconds to human readable format
seconds_to_human() {
    local seconds="$1"
    local hours=$((seconds / 3600))
    local minutes=$(((seconds % 3600) / 60))
    local secs=$((seconds % 60))
    
    if [[ $hours -gt 0 ]]; then
        printf "%dh %dm %ds\n" "$hours" "$minutes" "$secs"
    elif [[ $minutes -gt 0 ]]; then
        printf "%dm %ds\n" "$minutes" "$secs"
    else
        printf "%ds\n" "$secs"
    fi
}

# Get current timestamp
get_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Get ISO format timestamp
get_iso_timestamp() {
    date -u '+%Y-%m-%dT%H:%M:%SZ'
}

# ============ Input Validation ============

# Check if value is a number
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# Check if value is a valid email
is_email() {
    [[ "$1" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# Check if value is a valid IP address
is_ip_address() {
    [[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
}

# ============ Array Functions ============

# Check if array contains element
array_contains() {
    local element="$1"
    shift
    local array=("$@")
    
    for item in "${array[@]}"; do
        [[ "$item" == "$element" ]] && return 0
    done
    
    return 1
}

# Join array elements with separator
array_join() {
    local separator="$1"
    shift
    local array=("$@")
    
    local result=""
    for item in "${array[@]}"; do
        if [[ -z "$result" ]]; then
            result="$item"
        else
            result="${result}${separator}${item}"
        fi
    done
    
    echo "$result"
}

# ============ Utility Functions ============

# Print colored output
print_color() {
    local color="$1"
    local text="$2"
    
    case "$color" in
        red)    echo "\033[0;31m${text}\033[0m" ;;
        green)  echo "\033[0;32m${text}\033[0m" ;;
        yellow) echo "\033[0;33m${text}\033[0m" ;;
        blue)   echo "\033[0;34m${text}\033[0m" ;;
        *)      echo "$text" ;;
    esac
}

# Create a simple progress bar
progress_bar() {
    local current="$1"
    local total="$2"
    local width="${3:-30}"
    
    local percent=$((current * 100 / total))
    local filled=$((width * current / total))
    
    printf "["
    printf "%${filled}s" | tr ' ' '='
    printf "%$((width - filled))s" | tr ' ' '-'
    printf "] %d%%\n" "$percent"
}

# Print separator line
print_separator() {
    local char="${1:-=}"
    local width="${2:-50}"
    printf "%${width}s\n" | tr ' ' "$char"
}

# Export all functions so they're available when sourced
export -f init_logging log_message log_info log_warn log_error log_success
export -f error_exit command_exists require_command
export -f file_exists dir_exists create_dir safe_copy
export -f get_macos_version is_apple_silicon get_free_disk_space get_total_memory get_cpu_cores
export -f is_process_running kill_process_safe wait_for_process
export -f open_app close_app get_battery_percentage is_on_power
export -f has_internet get_local_ip get_public_ip
export -f seconds_to_human get_timestamp get_iso_timestamp
export -f is_number is_email is_ip_address
export -f array_contains array_join
export -f print_color progress_bar print_separator
