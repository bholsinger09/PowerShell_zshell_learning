# 📊 MacBook Pro Web Dashboard Guide

## Overview

Your Mac now has a beautiful **real-time web dashboard** that visualizes your daily performance metrics. Instead of reading text reports, you can see beautiful charts showing trends over time.

## Quick Start

### 1. Generate Dashboard Data
The dashboard data is generated automatically when you run the daily automation script:

```bash
bash ~/Documents/Zshell_Project/daily-automation.sh
```

Or manually update just the dashboard:

```bash
python3 ~/Documents/Zshell_Project/parse-reports.py
```

### 2. View the Dashboard

Open the dashboard in your browser:

```bash
# Option 1: Using open command
open ~/.mac_daily_reports/dashboard.html

# Option 2: Direct path in browser
file:///Users/benh/.mac_daily_reports/dashboard.html
```

The dashboard will automatically load all available reports and create interactive charts.

---

## Dashboard Features

### 📈 Interactive Charts

The dashboard displays four main performance charts with trend visualization:

#### 1. **Memory Usage Trend**
- Shows memory usage percentage over time
- Red gradient indicates high memory usage
- Helps identify memory leaks or resource-hungry processes
- **Status Indicators:**
  - 🟢 Normal (< 70%)
  - 🟡 Warning (70-85%)
  - 🔴 Critical (> 85%)

#### 2. **Disk Usage Trend**
- Displays home directory disk usage over time
- Blue gradient shows usage patterns
- Useful for tracking when you need to clean up files
- **Status Indicators:**
  - 🟢 Normal (< 70%)
  - 🟡 Warning (70-85%)
  - 🔴 Critical (> 85%)

#### 3. **CPU Load Trend**
- Shows average CPU load over time
- Green gradient indicates activity level
- Helps identify when your Mac was under heavy load
- **Status Indicators:**
  - 🟢 Normal (< 2)
  - 🟡 Warning (2-5)
  - 🟢 Green (very active but not concerning)

#### 4. **Battery Level Trend**
- Tracks battery percentage throughout the day
- Pink gradient shows charging/discharging
- Useful for MacBook users to optimize usage patterns
- **Status Indicators:**
  - 🟢 Normal (> 50%)
  - 🟡 Warning (20-50%)
  - 🔴 Critical (< 20%)

### 📋 Latest Metrics Table

A comprehensive table showing the last 10 data points with:
- **Timestamp:** When the measurement was taken
- **Memory:** Visual bar graph + percentage
- **Disk:** Visual bar graph + percentage
- **CPU Load:** Current load average
- **Battery:** Current battery percentage
- **Status:** Overall system health indicator

### 📊 Latest Stats Box

A quick glance at the most recent measurements:
- **Memory Usage:** Current % used
- **Disk Usage:** Current % used
- **CPU Load:** Current load average
- **Battery:** Current % charge

---

## Understanding the Data

### What Each Metric Means

| Metric | What It Measures | Why It Matters | Healthy Range |
|--------|-----------------|----------------|--------------------|
| **Memory** | RAM in use | Low = snappy, High = slow | < 70% |
| **Disk** | Storage used | Low = space to grow, High = cleanup needed | < 75% |
| **CPU Load** | Processor utilization | Low = responsive, High = laggy | < 2.0 |
| **Battery** | Power remaining | Helps plan charging | > 50% when using |

### Analyzing Trends

The dashboard shows up/down arrows next to status indicators:

- **📈 Up Arrow (Red):** Metric is increasing (potentially concerning)
- **📉 Down Arrow (Green):** Metric is decreasing (improving)

For example:
- Memory 📈 = Using more RAM over time → May need to close apps
- Disk 📉 = Using less space over time → Cleanup working!
- Battery 📈 = Charging up ✓
- Battery 📉 = Using battery over time (normal on laptop)

---

## Real-World Example

### Scenario: Your Mac is Running Slow

**Step 1:** Open the dashboard
```bash
open ~/.mac_daily_reports/dashboard.html
```

**Step 2:** Look at the Memory chart
- If it's at 98%, you're using too much RAM
- Check the "Top 5 Memory Processes" in the latest report
- Close unnecessary applications

**Step 3:** Look at the Disk chart
- If it's at 85%+, you need to clean up files
- Run cleanup commands from the reports
- Delete old downloads/caches

**Step 4:** Look at the CPU chart
- If it's consistently high, something is working hard
- Check Activity Monitor for specific processes
- Quit resource-intensive apps

---

## Customizing the Dashboard

### Changing Chart Time Ranges

Currently, the dashboard shows all available data. To see only recent data:

1. Manually delete older reports:
```bash
# Keep only last 7 days
find ~/.mac_daily_reports/report_*.txt -mtime +7 -delete
```

2. Regenerate the dashboard:
```bash
python3 ~/Documents/Zshell_Project/parse-reports.py
```

### Adjusting Alert Thresholds

Edit `parse-reports.py` to change when status colors trigger:

```python
# Find these lines and adjust numbers:
if latest > 85:  # Change 85 to your preferred threshold
    badge = 'status-critical'
```

### Styling and Colors

The dashboard HTML uses CSS gradients. To customize colors, edit the `<style>` section in `dashboard.html`:

```css
.stat-box.memory {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);  /* Change these colors */
}
```

---

## How the Dashboard Works

### File Structure

```
~/.mac_daily_reports/
├── dashboard.html           # The web dashboard (what you view)
├── dashboard-data.json      # Data file (generated by parse-reports.py)
├── report_*.txt             # Individual daily reports
└── daily.log                # Execution log
```

### The Workflow

```
┌─────────────────────────────────────┐
│ 1. Run daily-automation.sh          │
│    (LaunchAgent runs at 8 AM daily) │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 2. Generate report_YYYY-MM-DD_*.txt │
│    (Captures system metrics)        │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 3. Call update-dashboard.sh         │
│    (Triggered automatically)        │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 4. Run parse-reports.py             │
│    (Parses all reports)             │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 5. Generate dashboard-data.json     │
│    (JSON with all metrics)          │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 6. View dashboard.html              │
│    (Browser loads and renders)      │
└─────────────────────────────────────┘
```

---

## Troubleshooting

### Dashboard Shows "No Data Available"

**Problem:** You see an empty dashboard with a message about no data.

**Solutions:**
1. Run the daily automation script first:
   ```bash
   bash ~/Documents/Zshell_Project/daily-automation.sh
   ```

2. Check that reports were created:
   ```bash
   ls -la ~/.mac_daily_reports/report_*.txt
   ```

3. Manually update dashboard data:
   ```bash
   python3 ~/Documents/Zshell_Project/parse-reports.py
   ```

### Dashboard Charts Are Blank

**Problem:** The page loads but charts don't display.

**Solution:**
1. Check browser console for errors (F12 → Console tab)
2. Ensure JavaScript is enabled
3. Try a different browser
4. Check that `dashboard-data.json` exists:
   ```bash
   ls -la ~/.mac_daily_reports/dashboard-data.json
   ```

### Refresh Button Not Working

**Solution:** The dashboard auto-refreshes every 5 minutes, or you can manually:
1. Click the "🔄 Refresh" button in the dashboard header
2. Or reload the page (Cmd+R)
3. Or re-open the file in your browser

### Old Data Still Showing After Cleanup

**Problem:** You deleted old reports but they still appear in the dashboard.

**Solution:**
1. Clear browser cache (Cmd+Shift+Delete in Chrome)
2. Manually regenerate the JSON:
   ```bash
   python3 ~/Documents/Zshell_Project/parse-reports.py
   ```

---

## Advanced Usage

### Export Data for Analysis

The dashboard data is in standard JSON format, so you can export it:

```bash
# Copy to desktop for backup
cp ~/.mac_daily_reports/dashboard-data.json ~/Desktop/mac-metrics.json

# View raw JSON
cat ~/.mac_daily_reports/dashboard-data.json | jq .

# Query specific data (requires jq)
cat ~/.mac_daily_reports/dashboard-data.json | jq '.reports[] | {date, memory, disk}'
```

### Programmatic Access

Use the JSON data in your own scripts or tools:

```bash
# Get average memory usage
python3 << 'EOF'
import json

with open('/Users/benh/.mac_daily_reports/dashboard-data.json') as f:
    data = json.load(f)
    
memory_values = [r['memory'] for r in data['reports']]
avg_memory = sum(memory_values) / len(memory_values)
print(f"Average memory usage: {avg_memory:.1f}%")
EOF
```

### Integration with Other Tools

The dashboard HTML can be embedded or modified to:
- Send metrics to cloud services
- Create local web server for network viewing
- Generate PDF reports from the data
- Create Slack/Discord webhooks with alerts

---

## Performance Tips

### Make Dashboard Load Faster

1. **Remove old reports** (keeps JSON file small):
   ```bash
   # Keep only last 30 days
   find ~/.mac_daily_reports/report_*.txt -mtime +30 -delete
   python3 ~/Documents/Zshell_Project/parse-reports.py
   ```

2. **Compress data** by archiving old reports

3. **Use dedicated browser tab** for the dashboard (pin it)

---

## Next Steps

### Level 9: Auto-Remediation
Once you understand your metrics, you can:
- Automatically close apps when memory > 90%
- Auto-delete old files when disk > 85%
- Schedule smart restarts during low-usage times
- See detailed implementation in the curriculum

### Level 8.5: Email Alerts
Add notifications to the dashboard:
- Get emailed when thresholds are exceeded
- Desktop notifications for critical issues
- Daily summary email

### Level 10: Cloud Dashboard
Scale to multiple Macs:
- View all Macs in one dashboard
- Compare performance across machines
- Share with your team

---

## Files Created

| File | Purpose | Size |
|------|---------|------|
| `parse-reports.py` | Parser script (extracts metrics) | ~3.5 KB |
| `update-dashboard.sh` | Wrapper for parser | ~0.4 KB |
| `dashboard.html` | Web dashboard UI | ~24 KB |
| `dashboard-data.json` | Data file (grows with time) | ~10-50 KB |

---

## Support & Debugging

### Check Dashboard Status
```bash
# Verify files exist
ls -la ~/.mac_daily_reports/

# Check parser works
python3 ~/Documents/Zshell_Project/parse-reports.py

# View latest data
tail ~/.mac_daily_reports/dashboard-data.json

# Check recent reports
ls -lt ~/.mac_daily_reports/report_*.txt | head -5
```

### View Logs
```bash
# Check daily automation log
cat ~/.mac_daily_reports/daily.log | tail -20

# Check launchd service status
launchctl list | grep daily-automation
```

---

## Questions?

If the dashboard isn't working:

1. ✅ Run `daily-automation.sh` to generate data
2. ✅ Run `parse-reports.py` to convert to JSON
3. ✅ Check files exist in `~/.mac_daily_reports/`
4. ✅ Open `dashboard.html` directly (file:// path)
5. ✅ Check browser console for JavaScript errors
6. ✅ Try in a different browser
7. ✅ Refresh page or clear cache

---

**Enjoy your beautiful Mac performance dashboard! 📊✨**

Next: Level 9 - Auto-Remediation (automatic fixing)
