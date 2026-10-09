#!/bin/zsh

# MacBook Pro Daily Automation Suite
# Monitors performance and software updates
# Run daily with: crontab or launchd
# Usage: ./daily-automation.sh

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
REPORT_DIR="$HOME/.mac_daily_reports"
REPORT_FILE="$REPORT_DIR/report_$(date +%Y-%m-%d_%H-%M-%S).txt"
LOG_FILE="$REPORT_DIR/daily.log"

# Create report directory if needed
mkdir -p "$REPORT_DIR"

# ============ HEADER ============
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} MacBook Pro Daily Automation Report"
    echo -e "${BLUE}║${NC} Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Machine: $(hostname)"
    echo "User: $(whoami)"
    echo "Uptime: $(uptime -p)"
    echo ""
}

# ============ PERFORMANCE CHECKS ============
check_performance() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║ 1. SYSTEM PERFORMANCE${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # CPU Load
    echo -e "${YELLOW}CPU Load:${NC}"
    LOAD=$(uptime | awk -F'load average:' '{print $2}')
    echo "  $LOAD"
    
    # Memory Usage
    echo -e "${YELLOW}Memory Usage:${NC}"
    MEMORY=$(vm_stat | grep "Pages free" | awk '{print $3}' | tr -d '.')
    TOTAL_MEM=$(sysctl hw.memsize | awk '{print $2}')
    USED_MEM=$(( (TOTAL_MEM - (MEMORY * 4096)) / 1073741824 ))
    TOTAL_GB=$(( TOTAL_MEM / 1073741824 ))
    MEM_PERCENT=$(( (USED_MEM * 100) / TOTAL_GB ))
    echo "  Used: ${USED_MEM}GB / ${TOTAL_GB}GB (${MEM_PERCENT}%)"
    
    # Disk Usage
    echo -e "${YELLOW}Disk Usage (Home):${NC}"
    DISK=$(df -h $HOME | tail -1 | awk '{print $5, "used |", $4, "available"}')
    echo "  $DISK"
    
    # Battery (if available)
    if command -v pmset &> /dev/null; then
        echo -e "${YELLOW}Battery:${NC}"
        BATTERY=$(pmset -g batt | grep -o "[0-9]*%" | head -1)
        IS_CHARGING=$(pmset -g batt | grep "charging\|discharging")
        echo "  $BATTERY - $IS_CHARGING"
    fi
    
    echo ""
    
    # Performance Warnings
    if [ "$MEM_PERCENT" -gt 80 ]; then
        echo -e "${RED}⚠️  WARNING: High memory usage (${MEM_PERCENT}%)${NC}"
        echo "   Recommendation: Close unused applications"
    fi
    
    if echo "$DISK" | grep -q "9[0-9]%\|100%"; then
        echo -e "${RED}⚠️  WARNING: Low disk space!${NC}"
        echo "   Recommendation: Delete old files or backup to external drive"
    fi
    
    echo ""
}

# ============ PROCESS HEALTH ============
check_processes() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║ 2. APPLICATION HEALTH${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Apps to monitor
    declare -a APPS=("iTerm" "Code" "Xcode" "Docker" "Slack" "zoom.us")
    
    echo -e "${YELLOW}Running Applications:${NC}"
    for app in "${APPS[@]}"; do
        if pgrep -i "$app" > /dev/null 2>&1; then
            COUNT=$(pgrep -i "$app" | wc -l)
            MEM=$(ps aux | grep -i "$app" | grep -v grep | awk '{sum+=$6} END {printf "%.0f", sum/1024}')
            if [ -n "$MEM" ] && [ "$MEM" -gt 0 ]; then
                echo "  ✓ $app (${COUNT} process${COUNT:+es}, ${MEM}MB memory)"
            else
                echo "  ✓ $app (${COUNT} process${COUNT:+es})"
            fi
        else
            echo "  ○ $app (not running)"
        fi
    done
    
    echo ""
    echo -e "${YELLOW}Top 5 Memory-Hungry Processes:${NC}"
    ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "  %s: %.1fMB\n", $11, $6/1024}'
    
    echo ""
}

# ============ DISK CLEANUP ============
check_disk_cleanup() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║ 3. DISK CLEANUP SUGGESTIONS${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Trash size
    TRASH_SIZE=$(du -sh ~/.Trash 2>/dev/null | awk '{print $1}')
    echo -e "${YELLOW}Trash:${NC} $TRASH_SIZE"
    if [ "$TRASH_SIZE" != "0B" ]; then
        echo "  Suggestion: Empty trash to free space"
    fi
    
    # Temporary files
    TEMP_SIZE=$(du -sh /tmp 2>/dev/null | awk '{print $1}')
    echo -e "${YELLOW}Temp Files:${NC} $TEMP_SIZE"
    
    # Duplicate files (sample check)
    echo -e "${YELLOW}Old Downloads:${NC}"
    OLD_DOWNLOADS=$(find ~/Downloads -type f -mtime +30 2>/dev/null | wc -l)
    echo "  Files older than 30 days: $OLD_DOWNLOADS"
    if [ "$OLD_DOWNLOADS" -gt 0 ]; then
        echo "  Suggestion: Review and delete old downloads"
    fi
    
    # Cache sizes
    echo -e "${YELLOW}Cache Directories:${NC}"
    for cache_dir in ~/Library/Caches ~/.cache; do
        if [ -d "$cache_dir" ]; then
            CACHE_SIZE=$(du -sh "$cache_dir" 2>/dev/null | awk '{print $1}')
            echo "  $cache_dir: $CACHE_SIZE"
        fi
    done
    
    echo ""
}

# ============ SOFTWARE UPDATES ============
check_software_updates() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║ 4. SOFTWARE UPDATES${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # System updates
    echo -e "${YELLOW}macOS Updates:${NC}"
    softwareupdate -l 2>/dev/null | grep -i "* Label:" | head -5 || echo "  No updates available (system current)"
    
    echo ""
    echo -e "${YELLOW}Application Versions:${NC}"
    
    # iTerm2
    if [ -d "/Applications/iTerm.app" ]; then
        ITERM_VERSION=$(/Applications/iTerm.app/Contents/Info.plist | grep -A1 "CFBundleShortVersionString" | tail -1 | sed 's/.*<string>//;s/<\/string>.*//' 2>/dev/null || mdls -name kMDItemVersion /Applications/iTerm.app 2>/dev/null | awk '{print $NF}')
        echo "  iTerm2: $ITERM_VERSION"
    else
        echo "  iTerm2: Not installed"
    fi
    
    # VS Code
    if [ -d "/Applications/Visual Studio Code.app" ]; then
        VSCODE_VERSION=$(/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/package.json | grep '"version"' | head -1 | sed 's/.*: "//;s/".*//' 2>/dev/null || echo "$(ls -1 /Applications/Visual\ Studio\ Code.app 2>/dev/null | wc -l) files")
        echo "  VS Code: $VSCODE_VERSION"
    else
        echo "  VS Code: Not installed"
    fi
    
    # Xcode
    if command -v xcode-select &> /dev/null; then
        XCODE_VERSION=$(xcode-select -p 2>/dev/null | xargs -I {} sh -c 'plutil -p {}/../../version.plist 2>/dev/null | grep CFBundleShortVersionString | cut -d"=" -f2' || echo "Latest")
        echo "  Xcode: $XCODE_VERSION"
    else
        echo "  Xcode: Not installed"
    fi
    
    # Homebrew
    if command -v brew &> /dev/null; then
        echo -e "${YELLOW}Homebrew:${NC}"
        BREW_UPDATES=$(brew outdated 2>/dev/null | wc -l)
        if [ "$BREW_UPDATES" -gt 0 ]; then
            echo "  Updates available: $BREW_UPDATES packages"
            echo "  Update command: brew upgrade"
        else
            echo "  All packages current"
        fi
    fi
    
    echo ""
}

# ============ RECOMMENDATIONS ============
generate_recommendations() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║ 5. DAILY RECOMMENDATIONS${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${YELLOW}Performance Optimization:${NC}"
    echo "  ✓ Restart Mac weekly for optimal performance"
    echo "  ✓ Close unused applications"
    echo "  ✓ Clear browser cache monthly"
    echo ""
    
    echo -e "${YELLOW}Security & Updates:${NC}"
    echo "  ✓ Keep macOS current ($(softwareupdate -l 2>/dev/null | wc -l) updates available)"
    echo "  ✓ Update applications via App Store or brew"
    echo "  ✓ Enable automatic updates in System Settings"
    echo ""
    
    echo -e "${YELLOW}Backup:${NC}"
    LAST_BACKUP=$(ls -1 ~/Library/Mobile\ Documents 2>/dev/null | head -1)
    echo "  ✓ Verify Time Machine is running"
    echo "  ✓ Consider external backup for important files"
    echo ""
    
    echo -e "${YELLOW}Developer Tools:${NC}"
    echo "  ✓ Keep Xcode updated for latest SDKs"
    echo "  ✓ Update Homebrew packages: brew upgrade"
    echo "  ✓ Check VS Code extensions for updates"
    echo ""
}

# ============ QUICK ACTIONS ============
show_quick_actions() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║ 6. QUICK ACTIONS${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${YELLOW}Run these commands to optimize:${NC}"
    echo ""
    echo "  # Empty Trash"
    echo "  rm -rf ~/.Trash/*"
    echo ""
    echo "  # Clear old cache"
    echo "  rm -rf ~/Library/Caches/*"
    echo ""
    echo "  # Update Homebrew packages"
    echo "  brew upgrade"
    echo ""
    echo "  # Update system"
    echo "  softwareupdate -i -a"
    echo ""
    echo "  # Show largest files"
    echo "  du -sh ~/* 2>/dev/null | sort -rh | head -10"
    echo ""
}

# ============ FOOTER ============
print_footer() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ Report saved to: $REPORT_FILE${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Run daily with: crontab -e"
    echo "Add: 0 8 * * * $PWD/daily-automation.sh"
    echo ""
}

# ============ MAIN EXECUTION ============
main() {
    {
        print_header
        check_performance
        check_processes
        check_disk_cleanup
        check_software_updates
        generate_recommendations
        show_quick_actions
        print_footer
    } | tee "$REPORT_FILE"
    
    # Log to daily file too
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Report generated successfully" >> "$LOG_FILE"
}

# Run main
main
