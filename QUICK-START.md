# Quick Start Guide - Real-Time Monitoring System

## 🚀 Get Started in 2 Minutes

### Step 1: Start the System

```bash
bash ~/Documents/Zshell_Project/start-realtime-monitoring.sh start
```

**What this does**:
- Launches monitoring daemon (collects metrics every 2 seconds)
- Launches WebSocket server (broadcasts updates on port 8765)
- Creates log files for debugging

### Step 2: Open Dashboard in Browser

Choose one method:

**Option A: Direct File (Simplest)**
```bash
open ~/Documents/Zshell_Project/dashboard-realtime.html
```

**Option B: HTTP Server (Better for debugging)**
```bash
cd ~/Documents/Zshell_Project
python3 -m http.server 8000
# Then visit: http://localhost:8000/dashboard-realtime.html
```

### Step 3: Watch It Work

You should see:
- ✅ "Live - Connected" status indicator (green)
- 📊 5 real-time line charts updating smoothly
- 📈 Live stat boxes showing current values
- 🔔 Alerts when thresholds are exceeded

### Step 4: Stop When Done

```bash
bash ~/Documents/Zshell_Project/start-realtime-monitoring.sh stop
```

---

## 📊 What You're Looking At

### The Metrics

1. **Memory**: Wired memory percentage (0-100%)
   - Shows actual memory in use
   - Red warning: >80%

2. **CPU Usage**: Processor utilization (0-100%)
   - Real CPU load percentage
   - Red warning: >80%

3. **CPU Load**: System load average (varies)
   - How many processes want CPU time
   - Informational (no threshold)

4. **Disk Usage**: Disk space used (0-100%)
   - Home directory usage
   - Informational (no threshold)

5. **Battery**: Battery level (0-100%)
   - Only shown if on battery power
   - Normal for AC power: 100%

### The Dashboard

- **Live Charts**: Smooth line charts showing last 60 seconds of history
- **Stat Boxes**: Current values with change indicator (↑/↓)
- **Alerts**: Red warning box appears when thresholds exceeded
- **Status**: Green "Connected" = receiving updates
- **History**: 30 data points, updates every 2 seconds

---

## 🔧 Customization

### Change Update Interval

Edit `monitoring-daemon.zsh`:
```bash
INTERVAL=${1:-2}  # Change 2 to desired seconds
```

Or run with parameter:
```bash
./monitoring-daemon.zsh 5  # 5-second interval
```

### Change Alert Thresholds

Edit `dashboard-realtime.html`, find this section:
```javascript
const ALERT_THRESHOLDS = {
    memory: 80,      // Change to desired %
    cpu_percent: 80  // Change to desired %
};
```

### Change Chart History Size

Edit `monitoring-daemon.zsh`:
```bash
MAX_HISTORY=60  # Change to desired number of points
```

---

## 🐛 Troubleshooting

### "Connection Failed" or "Not Connected"

**Problem**: Dashboard shows "Not Connected" in red

**Solution**:
1. Check if services are running:
   ```bash
   bash ~/Documents/Zshell_Project/start-realtime-monitoring.sh status
   ```

2. Check if port 8765 is free:
   ```bash
   lsof -i :8765
   ```

3. Check logs:
   ```bash
   bash ~/Documents/Zshell_Project/start-realtime-monitoring.sh logs
   ```

### No Metrics Showing

**Problem**: Dashboard connected but charts are empty

**Solution**:
1. Wait 5-10 seconds (first data collection takes time)
2. Check metrics file:
   ```bash
   cat ~/.mac_daily_reports/realtime-metrics.json
   ```

3. If file is empty or invalid, restart daemon:
   ```bash
   bash ~/Documents/Zshell_Project/start-realtime-monitoring.sh restart
   ```

### Charts Not Updating

**Problem**: Charts frozen at same values

**Solution**:
1. Check daemon is running:
   ```bash
   ps aux | grep monitoring-daemon
   ```

2. Check metrics file is being updated:
   ```bash
   tail -f ~/.mac_daily_reports/realtime-metrics.json
   # Should show new entries every 2-3 seconds
   ```

3. Try reconnecting (refresh browser page)

### High CPU Usage

**Problem**: Dashboard using too much CPU

**Solution**:
1. Minimize chart animation:
   - Edit `dashboard-realtime.html`
   - Change `duration: 0` to `duration: 500`

2. Increase update interval:
   - Stop daemon: `stop-realtime-monitoring.sh stop`
   - Start with longer interval: `./monitoring-daemon.zsh 5`

### Port Already in Use

**Problem**: "Address already in use" error

**Solution**:
1. Find process on port 8765:
   ```bash
   lsof -i :8765
   ```

2. Check if it's your WebSocket server:
   ```bash
   bash start-realtime-monitoring.sh status
   ```

3. If it's an old process:
   ```bash
   bash start-realtime-monitoring.sh stop
   sleep 2
   bash start-realtime-monitoring.sh start
   ```

---

## 📚 More Information

- **Architecture**: See [REALTIME-MONITORING-GUIDE.md](REALTIME-MONITORING-GUIDE.md)
- **Test Results**: See [TESTING-REPORT.md](TESTING-REPORT.md)
- **Previous Work**: See [WORK-COMPLETED.md](WORK-COMPLETED.md)

---

## 💡 Pro Tips

### Monitor While Working
Keep the dashboard open in a browser window while you work. You'll instantly see when CPU or memory spikes.

### Debug Performance Issues
Use the live metrics to correlate what you're doing with resource usage:
1. Open dashboard
2. Open Activity Monitor alongside
3. Run your app
4. Watch metrics in both windows to identify issues

### Capture Baseline
Startup the system when your Mac is idle to see normal baseline usage. This helps you understand what's "normal" for your system.

### Test Alerts
To test if alerts are working:
1. Open Activity Monitor
2. Sort by CPU
3. Double-click "Finder" to launch multiple copies
4. Watch CPU spike on dashboard (should turn red when >80%)

---

**Ready to go?** Run this to start:
```bash
bash ~/Documents/Zshell_Project/start-realtime-monitoring.sh start && open ~/Documents/Zshell_Project/dashboard-realtime.html
```
