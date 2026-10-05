#!/bin/zsh
#
# Script Name: manage-applications.zsh
# Description: Automate opening and closing applications on macOS
# Author: DevOps Automation
# Date: 2024-10-05
# Version: 1.0
#
# Usage: ./manage-applications.zsh [COMMAND] [OPTIONS]
# Examples: 
#   ./manage-applications.zsh open Slack
#   ./manage-applications.zsh close Safari
#   ./manage-applications.zsh list
#   ./manage-applications.zsh launch-set dev
#

set -euo pipefail

# ============ Configuration ============
SCRIPT_DIR="${0:a:h}"

# Application sets for quick launching
declare -A APP_SETS
APP_SETS[dev]="VS Code Terminal Safari"
APP_SETS[work]="Slack Mail Calendar"
APP_SETS[media]="Spotify Music Photos"

# ============ Functions ============

# Error handling
error() {
    echo "❌ ERROR: $*" >&2
    exit 1
}

info() {
    echo "ℹ️  $*"
}

success() {
    echo "✅ $*"
}

warn() {
    echo "⚠️  $*"
}

# Check if application is running
is_app_running() {
    local app_name="$1"
    pgrep -f "$app_name" > /dev/null 2>&1 && return 0 || return 1
}

# Open an application
open_app() {
    local app_name="$1"
    
    if is_app_running "$app_name"; then
        warn "$app_name is already running"
        return 1
    fi
    
    info "Opening $app_name..."
    
    if open -a "$app_name" 2>/dev/null; then
        success "Opened $app_name"
        sleep 1
        return 0
    else
        error "Failed to open $app_name"
    fi
}

# Close an application
close_app() {
    local app_name="$1"
    
    if ! is_app_running "$app_name"; then
        warn "$app_name is not running"
        return 1
    fi
    
    info "Closing $app_name..."
    
    if osascript -e "tell application \"$app_name\" to quit" 2>/dev/null; then
        success "Closed $app_name"
        sleep 1
        return 0
    else
        warn "Could not gracefully close $app_name, force closing..."
        pkill -f "$app_name" || true
        success "Force closed $app_name"
    fi
}

# Get list of running applications
list_running_apps() {
    info "Currently running applications:"
    echo ""
    ps aux | grep -i "Applications/" | grep -v grep | awk '{print $NF}' | sed 's/.*\///' | sort -u
}

# Get all installed applications
list_installed_apps() {
    info "Installed applications:"
    echo ""
    ls /Applications/ | sed 's/\.app$//'
}

# Launch a set of applications
launch_app_set() {
    local set_name="$1"
    
    if [[ -z "${APP_SETS[$set_name]:-}" ]]; then
        error "Application set not found: $set_name"
    fi
    
    info "Launching application set: $set_name"
    
    local apps=(${APP_SETS[$set_name]})
    for app in "${apps[@]}"; do
        open_app "$app" || true
        sleep 0.5
    done
    
    success "Launched application set: $set_name"
}

# Close all applications except system apps
close_all_apps() {
    info "Closing all applications (keeping system apps)..."
    
    # List of system apps to keep running
    local system_apps=("Finder" "Dock" "SystemUIServer")
    
    local running_apps
    running_apps=$(ps aux | grep -i "/Applications/" | grep -v grep | awk '{print $NF}' | sed 's/.*\///' | sed 's/\.app$//' | sort -u)
    
    for app in ${running_apps}; do
        if [[ ! " ${system_apps[@]} " =~ " ${app} " ]]; then
            close_app "$app" || true
        fi
    done
    
    success "All applications closed (system apps preserved)"
}

# Show available application sets
show_app_sets() {
    info "Available application sets:"
    echo ""
    for set_name in "${(@k)APP_SETS}"; do
        echo "  $set_name: ${APP_SETS[$set_name]}"
    done
}

# Show help
show_help() {
    cat << EOF
macOS Application Manager

Usage: ./manage-applications.zsh [COMMAND] [OPTIONS]

Commands:
  open <app>              Open an application
  close <app>             Close an application gracefully
  list-running            List currently running applications
  list-installed          List all installed applications
  launch-set <set>        Launch a predefined set of applications
  close-all               Close all applications (except system apps)
  show-sets               Show available application sets
  help                    Show this help message

Examples:
  ./manage-applications.zsh open Slack
  ./manage-applications.zsh close Safari
  ./manage-applications.zsh launch-set dev
  ./manage-applications.zsh list-running

Available Sets:
EOF
    show_app_sets
}

# ============ Main Execution ============

main() {
    local command="${1:-help}"
    
    case "$command" in
        open)
            [[ -z "${2:-}" ]] && error "Application name required"
            open_app "$2"
            ;;
        close)
            [[ -z "${2:-}" ]] && error "Application name required"
            close_app "$2"
            ;;
        list-running)
            list_running_apps
            ;;
        list-installed)
            list_installed_apps
            ;;
        launch-set)
            [[ -z "${2:-}" ]] && error "Set name required"
            launch_app_set "$2"
            ;;
        close-all)
            close_all_apps
            ;;
        show-sets)
            show_app_sets
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            error "Unknown command: $command. Use 'help' for usage."
            ;;
    esac
}

main "$@"
