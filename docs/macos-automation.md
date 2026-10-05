# macOS Automation and DevOps Best Practices

## Key macOS-Specific Tools for DevOps Automation

### 1. launchd - macOS's Job Scheduler

Unlike Linux's cron, macOS uses `launchd` for scheduling tasks. This is more powerful and preferred.

#### Creating a LaunchAgent (runs when user logs in)

```zsh
# Create a .plist file in ~/Library/LaunchAgents/
cat > ~/Library/LaunchAgents/com.example.health-check.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.example.health-check</string>
    
    <key>ProgramArguments</key>
    <array>
        <string>/bin/zsh</string>
        <string>/Users/benh/Documents/Zshell_Project/scripts/monitoring/system-health-check.zsh</string>
    </array>
    
    <!-- Run every hour -->
    <key>StartInterval</key>
    <integer>3600</integer>
    
    <!-- Or use StartCalendarInterval for specific times -->
    <!-- <key>StartCalendarInterval</key>
    <array>
        <dict>
            <key>Hour</key>
            <integer>9</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>
    </array> -->
    
    <!-- Keep job running even if it crashes -->
    <key>KeepAlive</key>
    <false/>
    
    <!-- Run as user (not as root) -->
    <key>RunAtLoad</key>
    <true/>
    
    <!-- Standard output and error -->
    <key>StandardOutPath</key>
    <string>/var/log/system-health-check.log</string>
    <key>StandardErrorPath</key>
    <string>/var/log/system-health-check.log</string>
</dict>
</plist>
EOF

# Load the agent
launchctl load ~/Library/LaunchAgents/com.example.health-check.plist

# Check status
launchctl list com.example.health-check

# Unload when done
launchctl unload ~/Library/LaunchAgents/com.example.health-check.plist
```

#### Common launchd Commands

```zsh
# Load an agent
launchctl load ~/Library/LaunchAgents/com.example.script.plist

# Unload an agent
launchctl unload ~/Library/LaunchAgents/com.example.script.plist

# List all agents
launchctl list

# Check specific agent status
launchctl list | grep "com.example"

# View agent's log (if configured)
tail -f /var/log/system-health-check.log

# Force run an agent immediately
launchctl start com.example.health-check

# Stop a running agent
launchctl stop com.example.health-check

# Remove agent permanently
rm ~/Library/LaunchAgents/com.example.script.plist
launchctl unload ~/Library/LaunchAgents/com.example.script.plist
```

### 2. system_profiler - Get System Information

```zsh
# Get all hardware information
system_profiler SPHardwareDataType

# Get software information
system_profiler SPSoftwareDataType

# Get installed applications
system_profiler SPApplicationsDataType

# Get network information
system_profiler SPNetworkDataType

# Export to file
system_profiler SPHardwareDataType -xml > hw_info.xml
```

### 3. sysctl - Control System Parameters

```zsh
# Get system information
sysctl hw.model          # Hardware model
sysctl hw.ncpu           # Number of CPU cores
sysctl hw.memsize        # Total memory
sysctl kern.osversion    # OS version

# List all system parameters
sysctl -a

# Modify system parameters (requires sudo)
sudo sysctl -w kern.maxfilesperproc=8192
```

### 4. defaults - Access System Preferences

```zsh
# Read a setting
defaults read com.apple.dock persistent-apps

# Write a setting
defaults write com.apple.dock autohide -bool true

# Delete a setting
defaults delete com.apple.dock autohide

# Reset Dock settings to defaults
defaults delete com.apple.dock
killall Dock

# List all defaults domains
defaults domains | tr ',' '\n' | sort

# Export to plist file
defaults export com.apple.dock ~/Desktop/dock-settings.plist

# Import from plist file
defaults import com.apple.dock ~/Desktop/dock-settings.plist
```

### 5. pmset - Power Management

```zsh
# Show current battery status
pmset -g batt

# Show power settings
pmset -g

# Disable sleep on AC power (requires sudo)
sudo pmset -c sleep 0

# Enable sleep after 15 minutes on battery (requires sudo)
sudo pmset -b sleep 15

# Disable automatic restart on power loss
sudo pmset -g autorestart 0

# Check scheduled wake events
pmset -g sched
```

### 6. fs_usage - Monitor File System Activity

```zsh
# Monitor all file system operations (requires sudo)
sudo fs_usage

# Monitor specific process (requires sudo)
sudo fs_usage -e python

# Log to file (requires sudo)
sudo fs_usage -w > fs_activity.log &
```

### 7. osascript - AppleScript Integration

```zsh
# Show notification
osascript -e 'display notification "Hello!" with title "My Script"'

# Display dialog
osascript -e 'display dialog "Click OK" buttons {"OK", "Cancel"}'

# Get user input
osascript -e 'text returned of (display dialog "Enter text:" default answer "")'

# Open application
osascript -e 'tell application "Finder" to activate'

# Quit application
osascript -e 'tell application "Safari" to quit'
```

### 8. open - Launch Files and Applications

```zsh
# Open file with default application
open ~/Documents/file.pdf

# Open file with specific application
open -a "Visual Studio Code" ~/Documents/file.txt

# Open directory in Finder
open ~/Documents

# Open URL
open https://www.example.com

# Open with background app (no focus)
open -g -a "Script Editor" ~/script.applescript

# Open in new window
open -n -a "Safari" https://www.example.com
```

## macOS-Specific Automation Patterns

### Pattern 1: Startup Script with Status Notifications

```zsh
#!/bin/zsh

# Source common functions
source /path/to/common-functions.sh

main() {
    init_logging
    
    log_info "Mac startup automation starting..."
    
    # Check battery
    if ! is_on_power; then
        osascript -e 'display notification "Connected to power!" with title "Startup Check"'
    fi
    
    # Open work applications
    open_app "Slack" || true
    open_app "Mail" || true
    
    log_info "Startup complete"
}

main "$@"
```

### Pattern 2: Background Monitoring Script

```zsh
#!/bin/zsh

# Runs periodically via launchd to monitor system health
source /path/to/common-functions.sh

monitor() {
    local memory_percent=$(vm_stat | grep -E "Pages active" | awk '{print $3}')
    
    if (( memory_percent > 80 )); then
        osascript -e "display notification \"Memory usage high: ${memory_percent}%\" with title \"System Alert\""
    fi
}

monitor "$@"
```

### Pattern 3: Scheduled Cleanup Script

```zsh
#!/bin/zsh

# Runs daily to clean up system
source /path/to/common-functions.sh

cleanup() {
    log_info "Starting daily cleanup..."
    
    # Clean cache
    rm -rf ~/Library/Caches/* 2>/dev/null || true
    
    # Clean old logs
    find ~/.logs -type f -mtime +30 -delete
    
    log_success "Cleanup complete"
}

cleanup "$@"
```

## Security Considerations

### 1. Script Permissions

```zsh
# Make script executable and readable only by owner
chmod 700 script.zsh

# Make script readable by group
chmod 750 script.zsh

# Use strict permissions for sensitive scripts
chmod 600 sensitive-script.zsh
```

### 2. Secure Credential Handling

```zsh
# Store credentials securely using macOS Keychain
security find-generic-password -w -a username -s servicename

# Add credentials to Keychain
security add-generic-password -a username -s servicename -w password

# Never hardcode credentials in scripts!
```

### 3. Code Signing for Launch Agents

```zsh
# Sign your script (if deploying to others)
codesign -s - script.zsh

# Verify signature
codesign -v script.zsh
```

## Performance Tips

### 1. Optimize Script Startup

```zsh
# Avoid sourcing large files unnecessarily
# Use function libraries only when needed

# Cache command results
local result
result=$(expensive_operation)  # Cache once
use_result "$result"
use_result "$result"  # Reuse cached value
```

### 2. Use Efficient Commands

```zsh
# Bad: Multiple processes
for file in $(find . -name "*.txt"); do
    wc -l "$file"
done

# Good: Single pipeline
find . -name "*.txt" -exec wc -l {} +
```

### 3. Monitor Script Performance

```zsh
# Time your script
time ./script.zsh

# Profile with activity monitor (visual)
open -a "Activity Monitor"

# Check script memory usage
ps aux | grep script.zsh
```

## Debugging macOS Automation

### 1. Check launchd Logs

```zsh
# View recent errors
log show --predicate 'eventMessage contains "launchd"' --last 1h

# Follow logs in real-time
log stream --predicate 'eventMessage contains "launchd"'

# Get logs for specific agent
log show --predicate 'process == "launchd"' | grep "com.example"
```

### 2. Test Script Manually

```zsh
# Run with clean environment (like launchd does)
env -i /bin/zsh ./script.zsh

# Test with verbose mode
set -x
./script.zsh
set +x
```

### 3. Common Issues and Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Script not running | Agent not loaded | `launchctl load` the .plist file |
| Script stops early | Missing command | Use full paths to commands |
| No output in log | Incorrect plist path | Verify StandardOutPath and StandardErrorPath |
| Runs at wrong time | Wrong StartInterval | Check launchd plist timing values |
| Environment variables missing | Clean environment in launchd | Export variables in script |

## Useful Resources

- [Apple launchd Documentation](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchDaemons.html)
- [macOS Command Reference](https://ss64.com/osx/)
- [AppleScript Language Reference](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptX/)
- [Keychain Services Reference](https://developer.apple.com/documentation/security/keychain_services)

---

**Next**: Check out `config/startup-launchd/` for ready-to-use launchd configuration examples!
