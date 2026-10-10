#!/bin/zsh

# Setup Daily Automation
# Configures cron jobs for automatic daily runs
# Usage: ./setup-daily-automation.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ Daily Automation Setup${NC}"
    echo -e "${BLUE}║ Configures automatic daily checks and updates${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ============ MAKE SCRIPTS EXECUTABLE ============
setup_permissions() {
    echo -e "${CYAN}Setting up permissions...${NC}"
    
    chmod +x "$SCRIPT_DIR/daily-automation.sh"
    chmod +x "$SCRIPT_DIR/software-update.sh"
    
    echo -e "${GREEN}✓ Scripts are now executable${NC}"
    echo ""
}

# ============ CREATE DIRECTORIES ============
setup_directories() {
    echo -e "${CYAN}Creating directories...${NC}"
    
    mkdir -p ~/.mac_daily_reports
    mkdir -p ~/Scripts
    
    echo -e "${GREEN}✓ Directories created${NC}"
    echo ""
}

# ============ CREATE LAUNCHD PLIST ============
setup_launchd() {
    echo -e "${CYAN}Setting up automatic daily runs (launchd)...${NC}"
    
    PLIST_FILE="$HOME/Library/LaunchAgents/com.mac.daily-automation.plist"
    
    cat > "$PLIST_FILE" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.mac.daily-automation</string>
    <key>ProgramArguments</key>
    <array>
        <string>SCRIPT_PATH_HERE</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>8</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardErrorPath</key>
    <string>PATH_HERE/.mac_daily_reports/launchd.log</string>
    <key>StandardOutPath</key>
    <string>PATH_HERE/.mac_daily_reports/launchd.log</string>
</dict>
</plist>
EOF

    # Replace placeholders
    sed -i '' "s|SCRIPT_PATH_HERE|$SCRIPT_DIR/daily-automation.sh|g" "$PLIST_FILE"
    sed -i '' "s|PATH_HERE|$HOME|g" "$PLIST_FILE"
    
    # Load the plist
    launchctl load "$PLIST_FILE" 2>/dev/null || true
    
    echo -e "${GREEN}✓ Launchd configuration installed at: $PLIST_FILE${NC}"
    echo -e "${GREEN}✓ Script will run daily at 8:00 AM${NC}"
    echo ""
}

# ============ CRONTAB SETUP ============
setup_crontab() {
    echo -e "${CYAN}Setting up crontab...${NC}"
    echo ""
    echo "Would you like to use crontab instead of launchd?"
    read -p "Enter 'y' for crontab, 'n' for launchd only: " choice
    
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        # Check if cron entry exists
        if crontab -l 2>/dev/null | grep -q "daily-automation.sh"; then
            echo "Cron entry already exists"
        else
            # Add cron entry (8 AM daily)
            (crontab -l 2>/dev/null; echo "0 8 * * * $SCRIPT_DIR/daily-automation.sh") | crontab -
            echo -e "${GREEN}✓ Crontab entry added${NC}"
        fi
    fi
    echo ""
}

# ============ TEST RUN ============
test_run() {
    echo -e "${CYAN}Running test automation...${NC}"
    echo ""
    
    "$SCRIPT_DIR/daily-automation.sh" 2>&1 | head -50
    
    echo ""
    echo -e "${GREEN}✓ Test run completed${NC}"
    echo ""
}

# ============ VERIFY SETUP ============
verify_setup() {
    echo -e "${CYAN}Verifying setup...${NC}"
    echo ""
    
    # Check scripts exist
    if [ -x "$SCRIPT_DIR/daily-automation.sh" ]; then
        echo -e "${GREEN}✓ daily-automation.sh is executable${NC}"
    else
        echo -e "${RED}✗ daily-automation.sh not executable${NC}"
    fi
    
    if [ -x "$SCRIPT_DIR/software-update.sh" ]; then
        echo -e "${GREEN}✓ software-update.sh is executable${NC}"
    else
        echo -e "${RED}✗ software-update.sh not executable${NC}"
    fi
    
    # Check directories
    if [ -d ~/.mac_daily_reports ]; then
        echo -e "${GREEN}✓ Report directory exists: ~/.mac_daily_reports${NC}"
    else
        echo -e "${RED}✗ Report directory not found${NC}"
    fi
    
    # Check launchd
    PLIST_FILE="$HOME/Library/LaunchAgents/com.mac.daily-automation.plist"
    if [ -f "$PLIST_FILE" ]; then
        if launchctl list | grep -q "com.mac.daily-automation"; then
            echo -e "${GREEN}✓ Launchd automation is active${NC}"
        else
            echo -e "${YELLOW}⚠ Launchd plist exists but may not be loaded${NC}"
        fi
    fi
    
    echo ""
}

# ============ PRINT INSTRUCTIONS ============
print_instructions() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ SETUP COMPLETE!${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${YELLOW}What you can now do:${NC}"
    echo ""
    echo "1. View today's report:"
    echo "   open ~/.mac_daily_reports"
    echo ""
    echo "2. Run manual automation:"
    echo "   $SCRIPT_DIR/daily-automation.sh"
    echo ""
    echo "3. Check software updates:"
    echo "   $SCRIPT_DIR/software-update.sh check"
    echo ""
    echo "4. Update all software:"
    echo "   $SCRIPT_DIR/software-update.sh update"
    echo ""
    echo "5. View automation logs:"
    echo "   tail -f ~/.mac_daily_reports/daily.log"
    echo ""
    
    echo -e "${YELLOW}Scheduled runs:${NC}"
    echo "  Daily at 8:00 AM (via launchd)"
    echo "  Reports saved to: ~/.mac_daily_reports/"
    echo ""
    
    echo -e "${YELLOW}To disable automation:${NC}"
    echo "  launchctl unload ~/Library/LaunchAgents/com.mac.daily-automation.plist"
    echo ""
    
    echo -e "${YELLOW}To re-enable automation:${NC}"
    echo "  launchctl load ~/Library/LaunchAgents/com.mac.daily-automation.plist"
    echo ""
}

# ============ MAIN ============
main() {
    print_header
    
    setup_permissions
    setup_directories
    setup_launchd
    setup_crontab
    
    echo -e "${CYAN}Running test...${NC}"
    echo ""
    
    if test_run; then
        verify_setup
        print_instructions
    else
        echo -e "${RED}Test run failed. Please check the scripts.${NC}"
        exit 1
    fi
}

main
