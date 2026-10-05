# Setup Guide for Zshell DevOps Automation

## 1. Verify Your Zshell Installation

```zsh
# Check if zsh is installed and your default shell
echo $SHELL

# Should output: /bin/zsh

# Check zsh version
zsh --version

# Should be 5.0 or higher
```

## 2. Create Essential Directories

```zsh
# Create logs directory
mkdir -p ~/.logs

# Create scripts directory (if you want centralized scripts)
mkdir -p ~/DevOps_Scripts
```

## 3. Enable Command Execution

Make your scripts executable:

```zsh
# Single script
chmod +x path/to/script.zsh

# All scripts in a directory
chmod +x scripts/**/*.zsh
```

## 4. Add to Your PATH (Optional)

If you want to run scripts from anywhere:

```zsh
# Edit your ~/.zshrc
nano ~/.zshrc

# Add this line:
export PATH="$HOME/Documents/Zshell_Project/scripts:$PATH"

# Reload your shell
source ~/.zshrc
```

## 5. Set Up Logging

Create a centralized logging location:

```zsh
# Create logs directory
mkdir -p ~/.logs/zshell-automation

# Create a rotation script to keep logs manageable
touch ~/.logs/zshell-automation/.gitkeep
```

## 6. Install Optional Tools for Enhanced Automation

```zsh
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install useful command-line tools
brew install htop            # Better process viewer
brew install tree            # Directory visualization
brew install jq              # JSON processor
brew install curl            # HTTP requests
brew install wget            # File downloads
```

## 7. Understand macOS-Specific Tools

### launchd (for startup automation)

Instead of cron, macOS uses launchd for scheduling tasks. See `config/startup-launchd/` for examples.

```zsh
# List user launchd agents
launchctl list | grep -i user

# Load a plist file
launchctl load ~/Library/LaunchAgents/com.user.script.plist

# Unload a plist file
launchctl unload ~/Library/LaunchAgents/com.user.script.plist

# Check if a service is running
launchctl list com.user.script
```

### System Information Commands

```zsh
# System information
system_profiler SPSoftwareDataType

# Hardware information
system_profiler SPHardwareDataType

# CPU info
sysctl -n hw.ncpu

# Memory info
vm_stat

# Disk usage
df -h

# Network info
ifconfig
networksetup -getinfo Wi-Fi
```

## 8. Test Your First Script

Create a simple test script:

```zsh
#!/bin/zsh

# Save as: test-setup.zsh
echo "Testing Zshell Setup"
echo "Shell: $SHELL"
echo "Version: $(zsh --version)"
echo "Home: $HOME"
echo "Current Path: $PWD"

# Check some command-line tools
for cmd in curl git zsh; do
    if command -v "$cmd" > /dev/null 2>&1; then
        echo "✓ $cmd is installed"
    else
        echo "✗ $cmd is NOT installed"
    fi
done
```

Make it executable and run:

```zsh
chmod +x test-setup.zsh
./test-setup.zsh
```

## 9. IDE/Editor Setup

### Using VS Code (Recommended)

```zsh
# Install VS Code extensions for shell scripting:
# 1. "Shell Format" by foxundermoon
# 2. "ShellCheck" by timonwong
# 3. "Even Better TOML" for config files

# Install shellcheck (linter)
brew install shellcheck
```

### Using other editors

- **nano/vim**: Built-in, but steeper learning curve
- **BBEdit**: macOS-specific, great shell support
- **Sublime Text**: Good with plugins

## 10. Common Issues & Solutions

### Issue: Permission Denied
```zsh
# Solution: Make script executable
chmod +x script.zsh
```

### Issue: Command Not Found
```zsh
# Solution: Use full path
/bin/zsh ./script.zsh

# Or ensure script is in PATH
export PATH="$PATH:$(pwd)"
```

### Issue: Script Works Interactively but Not in launchd
```zsh
# Solution: Use full paths to all commands in your script
/usr/bin/env python3    # Good
python3                 # May fail in launchd context

# Test script with env reset:
env -i /bin/zsh ./script.zsh
```

### Issue: Output Not Captured in Logs
```zsh
# Solution: Redirect both stdout and stderr
echo "output" > logfile.log 2>&1

# Or in launchd plist:
<key>StandardOutPath</key>
<string>/var/log/myscript.log</string>
<key>StandardErrorPath</key>
<string>/var/log/myscript.log</string>
```

## 11. Next Steps

1. Read `BEST_PRACTICES.md` for coding standards
2. Review `macos-automation.md` for macOS-specific tips
3. Study the `examples/basic/` directory
4. Create your first automation script in `scripts/utilities/`
5. Test thoroughly before scheduling with launchd

## 12. Resources

- [Zshell Manual](http://zsh.sourceforge.net/Doc/Release/zsh_toc.html)
- [macOS launchd Documentation](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchDaemons.html)
- [Apple System Events Reference](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptX/Concepts/osa.html)
- [Shell Script Best Practices](https://mywiki.wooledge.org/BashGuide)

---

**Ready to start?** Head over to `examples/basic/` to learn fundamental Zshell concepts!
