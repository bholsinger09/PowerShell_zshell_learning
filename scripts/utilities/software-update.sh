#!/bin/zsh

# Software Update Manager
# Checks and updates all developer tools and applications
# Usage: ./software-update.sh [check|update|all]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
COMMAND=${1:-check}

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ Software Update Manager${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ============ CHECK XCODE ============
check_xcode() {
    echo -e "${CYAN}Checking Xcode...${NC}"
    
    if ! command -v xcode-select &> /dev/null; then
        echo -e "${RED}✗ Xcode not installed${NC}"
        return 1
    fi
    
    XCODE_PATH=$(xcode-select -p 2>/dev/null)
    
    if [ -d "$XCODE_PATH" ]; then
        echo -e "${GREEN}✓ Xcode installed at: $XCODE_PATH${NC}"
        
        # Check for updates
        softwareupdate -l 2>/dev/null | grep -i "xcode\|command line tools" || echo "  (No updates available)"
        return 0
    else
        echo -e "${RED}✗ Xcode tools not properly installed${NC}"
        return 1
    fi
}

update_xcode() {
    echo -e "${YELLOW}Updating Xcode...${NC}"
    
    # Accept Xcode license
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    sudo xcodebuild -license accept 2>/dev/null || true
    
    echo -e "${GREEN}✓ Xcode tools updated${NC}"
}

# ============ CHECK ITERM ============
check_iterm() {
    echo -e "${CYAN}Checking iTerm2...${NC}"
    
    if [ -d "/Applications/iTerm.app" ]; then
        ITERM_VERSION=$(mdls -name kMDItemVersion /Applications/iTerm.app 2>/dev/null | awk '{print $NF}')
        echo -e "${GREEN}✓ iTerm2 installed (version $ITERM_VERSION)${NC}"
        return 0
    else
        echo -e "${RED}✗ iTerm2 not found${NC}"
        echo "  Install: brew install --cask iterm2"
        return 1
    fi
}

update_iterm() {
    echo -e "${YELLOW}Updating iTerm2...${NC}"
    
    if command -v brew &> /dev/null; then
        brew upgrade --cask iterm2
        echo -e "${GREEN}✓ iTerm2 updated${NC}"
    else
        echo -e "${YELLOW}Homebrew not found. Install iTerm2 manually or install Homebrew first.${NC}"
    fi
}

# ============ CHECK VS CODE ============
check_vscode() {
    echo -e "${CYAN}Checking VS Code...${NC}"
    
    if [ -d "/Applications/Visual Studio Code.app" ]; then
        VSCODE_VERSION=$(/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/package.json 2>/dev/null | grep '"version"' | head -1 | sed 's/.*: "//;s/".*//')
        echo -e "${GREEN}✓ VS Code installed (version $VSCODE_VERSION)${NC}"
        return 0
    else
        echo -e "${RED}✗ VS Code not found${NC}"
        echo "  Install: brew install --cask visual-studio-code"
        return 1
    fi
}

update_vscode() {
    echo -e "${YELLOW}Updating VS Code...${NC}"
    
    if command -v brew &> /dev/null; then
        brew upgrade --cask visual-studio-code
        echo -e "${GREEN}✓ VS Code updated${NC}"
    else
        echo -e "${YELLOW}Homebrew not found. Install VS Code manually or install Homebrew first.${NC}"
    fi
}

# ============ CHECK HOMEBREW ============
check_homebrew() {
    echo -e "${CYAN}Checking Homebrew...${NC}"
    
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}✗ Homebrew not installed${NC}"
        echo "  Install: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        return 1
    fi
    
    BREW_VERSION=$(brew --version | head -1)
    echo -e "${GREEN}✓ Homebrew installed ($BREW_VERSION)${NC}"
    
    OUTDATED=$(brew outdated 2>/dev/null | wc -l)
    if [ "$OUTDATED" -gt 0 ]; then
        echo -e "${YELLOW}⚠ $OUTDATED packages have updates available${NC}"
    else
        echo -e "${GREEN}✓ All packages current${NC}"
    fi
    
    return 0
}

update_homebrew() {
    echo -e "${YELLOW}Updating Homebrew packages...${NC}"
    
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}✗ Homebrew not installed${NC}"
        return 1
    fi
    
    brew update
    brew upgrade
    brew cleanup
    
    echo -e "${GREEN}✓ Homebrew packages updated${NC}"
}

# ============ CHECK MACOS ============
check_macos() {
    echo -e "${CYAN}Checking macOS...${NC}"
    
    MACOS_VERSION=$(sw_vers -productVersion)
    MACOS_BUILD=$(sw_vers -buildVersion)
    
    echo -e "${GREEN}✓ macOS $MACOS_VERSION (Build $MACOS_BUILD)${NC}"
    
    # Check for system updates
    UPDATES=$(softwareupdate -l 2>/dev/null | grep -c "* Label:" || echo 0)
    
    if [ "$UPDATES" -gt 0 ]; then
        echo -e "${YELLOW}⚠ $UPDATES system updates available${NC}"
        softwareupdate -l 2>/dev/null | grep "* Label:" | sed 's/^/  /'
    else
        echo -e "${GREEN}✓ macOS is current${NC}"
    fi
    
    return 0
}

update_macos() {
    echo -e "${YELLOW}Installing system updates...${NC}"
    echo "This may require administrator password and restart."
    
    sudo softwareupdate -i -a
    
    echo -e "${GREEN}✓ System updates installed${NC}"
}

# ============ SUMMARY REPORT ============
generate_summary() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ SUMMARY${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo "Checked components:"
    echo "  • Xcode and Command Line Tools"
    echo "  • iTerm2"
    echo "  • Visual Studio Code"
    echo "  • Homebrew packages"
    echo "  • macOS system updates"
    echo ""
    
    echo "For automated updates, add to crontab:"
    echo "  0 8 * * 0 $PWD/software-update.sh all"
    echo "(Runs every Sunday at 8 AM)"
    echo ""
}

# ============ MAIN EXECUTION ============
main() {
    print_header
    
    case "$COMMAND" in
        check)
            echo -e "${CYAN}═══ CHECKING INSTALLED SOFTWARE ═══${NC}"
            echo ""
            check_xcode
            echo ""
            check_iterm
            echo ""
            check_vscode
            echo ""
            check_homebrew
            echo ""
            check_macos
            ;;
            
        update)
            echo -e "${CYAN}═══ UPDATING INSTALLED SOFTWARE ═══${NC}"
            echo ""
            echo "This will update development tools."
            echo "Some updates may require administrator password."
            echo ""
            
            read -p "Continue? (y/n) " -n 1 -r
            echo ""
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                update_xcode
                echo ""
                update_iterm
                echo ""
                update_vscode
                echo ""
                update_homebrew
                echo ""
                update_macos
            else
                echo "Update cancelled"
            fi
            ;;
            
        all)
            echo -e "${CYAN}═══ CHECKING ALL SOFTWARE ═══${NC}"
            echo ""
            check_xcode
            echo ""
            check_iterm
            echo ""
            check_vscode
            echo ""
            check_homebrew
            echo ""
            check_macos
            echo ""
            generate_summary
            ;;
            
        *)
            echo "Usage: $0 [check|update|all]"
            echo ""
            echo "  check   - Check installed software versions"
            echo "  update  - Update all installed software"
            echo "  all     - Check all and generate summary"
            echo ""
            exit 1
            ;;
    esac
    
    generate_summary
}

main
