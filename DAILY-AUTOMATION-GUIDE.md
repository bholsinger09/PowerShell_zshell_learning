# 🤖 MacBook Pro Daily Automation Suite

## Overview

This is a **production-ready automation system** for your MacBook Pro that:
- ✅ Monitors performance daily
- ✅ Checks software versions and updates
- ✅ Provides optimization recommendations
- ✅ Runs automatically every morning
- ✅ Generates detailed reports

Uses everything you learned:
- Variables & environment
- Conditionals & logic
- Pipes & text processing
- Processes & system monitoring
- Functions for organization
- Arrays for data management

---

## Quick Start

### 1️⃣ **Setup (One-time only)**

```bash
cd ~/Documents/Zshell_Project
chmod +x daily-automation.sh software-update.sh setup-daily-automation.sh
./setup-daily-automation.sh
```

This will:
- Set up automatic runs via launchd (8 AM daily)
- Create report directories
- Run a test automation
- Verify everything works

### 2️⃣ **First Manual Run**

```bash
./daily-automation.sh
```

You'll see:
- System performance (CPU, memory, disk)
- Running applications
- Disk cleanup suggestions
- Software update status
- Optimization recommendations
- Quick action commands

Report saved to: `~/.mac_daily_reports/`

### 3️⃣ **Check Software Updates**

```bash
./software-update.sh check
```

Shows versions of:
- Xcode
- iTerm2
- VS Code
- Homebrew
- macOS

---

## What Each Script Does

### `daily-automation.sh`

**Main automation report** - Runs every morning

```bash
1. SYSTEM PERFORMANCE
   - CPU load average
   - Memory usage (GB and %)
   - Disk usage
   - Battery level
   - Performance warnings

2. APPLICATION HEALTH
   - Running apps (iTerm, VS Code, Xcode, etc)
   - Memory usage per app
   - Top 5 memory-hungry processes

3. DISK CLEANUP SUGGESTIONS
   - Trash size
   - Temp files
   - Old downloads
   - Cache directories

4. SOFTWARE UPDATES
   - macOS updates available
   - App versions (iTerm, VS Code, Xcode)
   - Homebrew package updates

5. DAILY RECOMMENDATIONS
   - Performance tips
   - Security updates
   - Backup reminders
   - Developer tool suggestions

6. QUICK ACTIONS
   - Commands to optimize
   - Empty trash
   - Clear cache
   - Update software
```

### `software-update.sh`

**Software version and update manager**

Commands:
```bash
./software-update.sh check    # Show current versions
./software-update.sh update   # Update all software
./software-update.sh all      # Check and summarize
```

Handles:
- Xcode & Command Line Tools
- iTerm2
- VS Code
- Homebrew packages
- macOS system updates

---

## Automatic Scheduling

### Via Launchd (Recommended for macOS)

The setup script creates: `~/Library/LaunchAgents/com.mac.daily-automation.plist`

Runs **daily at 8:00 AM**

**Management commands:**
```bash
# Check if loaded
launchctl list | grep daily-automation

# Manually trigger
launchctl start com.mac.daily-automation

# Disable automation
launchctl unload ~/Library/LaunchAgents/com.mac.daily-automation.plist

# Re-enable automation
launchctl load ~/Library/LaunchAgents/com.mac.daily-automation.plist
```

### Via Crontab (Alternative)

If you prefer cron instead:

```bash
# Edit crontab
crontab -e

# Add this line (daily at 8 AM):
0 8 * * * /Users/benh/Documents/Zshell_Project/daily-automation.sh
```

---

## Reports

### Location
```bash
~/.mac_daily_reports/
├── report_2026-10-09_08-00-00.txt     (Today's report)
├── report_2026-10-08_08-00-00.txt     (Yesterday)
├── daily.log                          (Summary log)
└── launchd.log                        (Automation logs)
```

### View Today's Report
```bash
cat ~/.mac_daily_reports/report_$(date +%Y-%m-%d)_*.txt | head -100
```

### View All Reports
```bash
ls -lh ~/.mac_daily_reports/
```

### Watch for New Reports
```bash
watch "ls -lh ~/.mac_daily_reports/ | head -10"
```

---

## Output Examples

### Daily Automation Report

```
╔════════════════════════════════════════════════════════╗
║ MacBook Pro Daily Automation Report
║ Generated: 2026-10-09 08:00:00
╚════════════════════════════════════════════════════════╝

Machine: benhs-macbook
User: benh
Uptime: 2 days, 14 hours

╔════════════════════════════════════════════════════════╗
║ 1. SYSTEM PERFORMANCE
╚════════════════════════════════════════════════════════╝

CPU Load:
  load average: 2.14, 1.98, 1.87

Memory Usage:
  Used: 12GB / 16GB (75%)

Disk Usage (Home):
  72% used | 234GB available

Battery:
  87% - charging

⚠️  WARNING: High memory usage (75%)
   Recommendation: Close unused applications
```

### Software Update Check

```
Checking Xcode...
✓ Xcode installed at: /Applications/Xcode.app/Contents/Developer

Checking iTerm2...
✓ iTerm2 installed (version 3.4.18)

Checking VS Code...
✓ VS Code installed (version 1.93.0)

Checking Homebrew...
✓ Homebrew installed (Homebrew 4.1.1)
⚠ 5 packages have updates available
```

---

## Customization

### Change Daily Run Time

Edit the launchd plist:
```bash
nano ~/Library/LaunchAgents/com.mac.daily-automation.plist
```

Change the `StartCalendarInterval`:
```xml
<dict>
    <key>Hour</key>
    <integer>7</integer>      <!-- 7 AM instead of 8 -->
    <key>Minute</key>
    <integer>30</integer>     <!-- At 30 minutes -->
</dict>
```

Then reload:
```bash
launchctl unload ~/Library/LaunchAgents/com.mac.daily-automation.plist
launchctl load ~/Library/LaunchAgents/com.mac.daily-automation.plist
```

### Monitor Specific Applications

Edit `daily-automation.sh`:
```bash
# Change this line (around line 80):
declare -a APPS=("iTerm" "Code" "Xcode" "Docker" "Slack" "zoom.us")

# Add your apps:
declare -a APPS=("iTerm" "Code" "Xcode" "MyApp" "Node" "Python")
```

### Set Memory Warning Threshold

Edit `daily-automation.sh`:
```bash
# Change this line (around line 95):
if [ "$MEM_PERCENT" -gt 80 ]; then

# For example, warn at 70%:
if [ "$MEM_PERCENT" -gt 70 ]; then
```

---

## Common Tasks

### View Performance Trends
```bash
# Show memory usage for last 7 days
for file in ~/.mac_daily_reports/report_*.txt; do
    echo "=== $(basename $file) ===" 
    grep "Memory Usage:" "$file"
done
```

### Check Update History
```bash
# What software was updated?
grep -h "Updated\|updates available" ~/.mac_daily_reports/*.txt | sort | uniq -c
```

### Find Problematic Days
```bash
# Show HIGH memory warnings
grep "WARNING" ~/.mac_daily_reports/report_*.txt
```

### Export Weekly Summary
```bash
# Create summary of past 7 days
cat ~/.mac_daily_reports/report_*.txt | tail -100 > weekly_summary.txt
```

---

## Troubleshooting

### Automation Not Running

**Check if launchd service is loaded:**
```bash
launchctl list | grep com.mac.daily-automation
```

**If not loaded:**
```bash
launchctl load ~/Library/LaunchAgents/com.mac.daily-automation.plist
```

**Check error logs:**
```bash
cat ~/.mac_daily_reports/launchd.log
```

### Scripts Not Executable

```bash
chmod +x ~/Documents/Zshell_Project/*.sh
```

### Permission Denied

Some commands need `sudo`:
```bash
# If you see permission errors, add sudo to specific commands in the script
sudo softwareupdate -l
```

### Can't Find Reports

```bash
# Create missing directory
mkdir -p ~/.mac_daily_reports

# Check directory exists
ls -la ~/.mac_daily_reports/
```

---

## Advanced Usage

### Manual Cron Trigger
```bash
# Run immediately outside of schedule
launchctl start com.mac.daily-automation
```

### View Real-time Logs
```bash
tail -f ~/.mac_daily_reports/launchd.log
```

### Disable Specific Reports

Comment out sections in `daily-automation.sh`:
```bash
# check_performance      # Disable performance checks
# check_processes        # Disable app health
```

### Run Only Specific Checks

Create aliases in your `~/.zshrc`:
```bash
alias daily-check='$HOME/Documents/Zshell_Project/daily-automation.sh'
alias update-check='$HOME/Documents/Zshell_Project/software-update.sh check'
alias update-all='$HOME/Documents/Zshell_Project/software-update.sh update'
```

---

## What You're Using From Your Learning

### Level 1: Variables & Arguments
```bash
declare -a APPS=("app1" "app2")  # Arrays
REPORT_DIR="$HOME/.mac_daily_reports"
```

### Level 2: If/Then Conditionals
```bash
if [ "$MEM_PERCENT" -gt 80 ]; then
    echo "High memory!"
fi
```

### Level 3: Pipes & Text Processing
```bash
ps aux --sort=-%mem | head -6
grep "* Label:" | sed 's/^/  /'
```

### Level 4: Text Editing
```bash
| awk '{print $5, $4}'
| sed 's/.*: "//;s/".*//'
```

### Level 5: Environment Variables
```bash
HOME_DIR="${HOME:-.}"
COMMAND=${1:-check}
```

### Level 6: Processes & Monitoring
```bash
pgrep -i "$app"
ps aux | grep -v grep
kill, pkill commands
```

---

## Daily Workflow

### Morning (Automatic)
- 8:00 AM: Report generated automatically
- Check for critical issues (high memory, low disk)
- Review recommendations

### Whenever
```bash
# Quick check
./daily-automation.sh

# Update software
./software-update.sh update

# View reports
ls ~/.mac_daily_reports/
```

### Weekly
```bash
# Full system check and optimization
./daily-automation.sh
./software-update.sh all
```

---

## Summary

This automation system:
- ✅ Runs **daily automatically**
- ✅ **Monitors performance** (CPU, memory, disk)
- ✅ **Checks software** (Xcode, iTerm, VS Code)
- ✅ **Generates reports** with recommendations
- ✅ **Keeps history** for trend analysis
- ✅ **Suggests actions** to optimize

**Start automation:**
```bash
./setup-daily-automation.sh
```

**Run manually anytime:**
```bash
./daily-automation.sh
./software-update.sh check
```

**View reports:**
```bash
open ~/.mac_daily_reports/
```

---

## Next Steps

1. Run setup: `./setup-daily-automation.sh`
2. Wait for first automated run (8 AM tomorrow)
3. Review reports in `~/.mac_daily_reports/`
4. Customize as needed
5. Build additional automation scripts!

Good luck! This is professional DevOps automation! 🚀
