# Zshell Project Structure

## Overview
This project contains zshell learning materials, real-time MacBook monitoring system, and automation scripts.

## 📁 Directory Organization

### `/docs` - Documentation
Comprehensive guides, references, and reports for the project.

#### `/docs/guides/`
- Learning and how-to guides
- **DAILY-AUTOMATION-GUIDE.md** - Daily task automation
- **INTERACTIVE-LEARNING-GUIDE.md** - Interactive learning paths
- **QUICK-START.md** / **QUICKSTART.md** - Getting started
- **REALTIME-MONITORING-GUIDE.md** - Real-time monitoring setup

#### `/docs/references/`
- Technical reference documentation
- **IF_THEN_REFERENCE.md** - Conditional logic reference
- **PIPES_REFERENCE.md** - Pipe and redirection reference
- **PROCESSES-SIGNALS-REFERENCE.md** - Process management
- **ENVIRONMENT-VARIABLES-REFERENCE.md** - Environment variables
- **TEXT_EDITING_REFERENCE.md** - Text editing tools
- **BEST_PRACTICES.md** - zshell best practices

#### `/docs/reports/`
- Test results and session documentation
- **AUTOMATION-TEST-REPORT.md** - Automation testing results
- **TESTING-REPORT.md** / **TESTING-SUMMARY.md** - Test summaries
- **SESSION-SUMMARY.md** - Session overviews
- **WORK-COMPLETED.md** - Completed work tracking
- **DASHBOARD-GUIDE.md** - Dashboard documentation
- Plus additional learning reports

#### `/docs/setup-guide.md`
- Initial setup instructions for the project

### `/scripts` - Executable Scripts

#### `/scripts/daemon/`
Real-time monitoring daemon processes
- **monitoring-daemon-v2.zsh** - Enhanced daemon (CURRENT)
- **monitoring-daemon.zsh** - Original daemon

#### `/scripts/server/`
WebSocket and network servers
- **websocket-server-v2.py** - Enhanced WebSocket server (CURRENT)
- **websocket-server.py** - Original WebSocket server

#### `/scripts/utilities/`
Helper and utility scripts
- **parse-reports.py** - Report parsing utility
- **update-dashboard.sh** - Dashboard update script
- **daily-automation.sh** - Daily task automation
- **software-update.sh** - Software update utility

#### `/scripts/setup/`
Installation and configuration scripts
- **setup-daily-automation.sh** - Configure daily automation
- **start-realtime-monitoring.sh** - Start monitoring services
- **start-dashboard-server.sh** - Start dashboard HTTP server

### `/web` - Web Applications
Web-based interfaces and dashboards

#### `/web/public/`
- **dashboard-realtime.html** - Real-time MacBook monitoring dashboard
  - Live system metrics (CPU, Memory, Disk, Battery)
  - Network traffic monitoring (Download, Upload, Total Mbps)
  - Active connections tracking
  - Top processes display
  - Auto-refresh every 2 minutes
  - WebSocket real-time updates

### `/examples` - Learning Examples

#### `/examples/basic/`
Foundational zshell concepts
- Variables and types
- Conditionals (if-then)
- Pipes and command chaining
- Text editing
- Sed, AWK, grep
- Command substitution
- Environment variables
- Process signals

#### `/examples/intermediate/`
Intermediate zshell techniques

#### `/examples/advanced/`
Advanced zshell patterns

### `/config` - Configuration Files

#### `/config/startup-launchd`
- launchd configuration for automated startup

### `/monitoring` - Monitoring Configuration

#### `/monitoring/config/`
- Monitoring daemon configuration files

## 🚀 Quick Start

### 1. Start Real-Time Monitoring
```bash
./scripts/setup/start-realtime-monitoring.sh
```

This will start:
- Monitoring daemon (collects metrics every 3 seconds)
- WebSocket server (broadcasts on port 8765)
- HTTP server (serves dashboard on port 8000)

### 2. Access Dashboard
Open browser to: **http://localhost:8000/web/public/dashboard-realtime.html**

### 3. View Live Metrics
- CPU, Memory, Disk, Battery usage
- Real-time network download/upload speeds
- Active TCP connections
- Top 5 processes by CPU usage
- Auto-refresh every 2 minutes

## 📊 Real-Time Monitoring System

### Architecture
```
┌─────────────────┐
│  Monitoring     │
│  Daemon (zsh)   │  Collects metrics every 3 seconds
│  monitoring-    │
│  daemon-v2.zsh  │
└────────┬────────┘
         │ Writes JSON
         ↓
┌─────────────────────┐
│ ~/.mac_daily_        │
│ reports/realtime-   │
│ metrics.json        │
└────────┬────────────┘
         │ Reads every 2.5s
         ↓
┌──────────────────────┐
│ WebSocket Server     │
│ websocket-server-    │
│ v2.py               │
└────────┬─────────────┘
         │ ws://localhost:8765
         ↓
┌──────────────────────┐
│ Browser Dashboard    │
│ dashboard-           │
│ realtime.html        │
└──────────────────────┘
```

### Metrics Collected
- **System:** Memory %, CPU %, Disk %, Battery %, CPU Load
- **Network:** Download Mbps, Upload Mbps, Total Mbps, Connection count
- **Processes:** Top 5 by CPU usage
- **Connections:** Active TCP connections with remote IPs

### Key Features
✅ Real-time metrics (updated every 3 seconds)
✅ Live updating charts with 2-minute history
✅ Auto-refresh dashboard every 2 minutes
✅ WebSocket server for live data streaming
✅ File-based state tracking for reliability
✅ Network traffic detection with byte delta calculation
✅ Async/await operations (non-blocking)
✅ Connection count tracking
✅ Process monitoring

## 📝 Key Files

### Most Important Files
| File | Purpose | Status |
|------|---------|--------|
| `scripts/daemon/monitoring-daemon-v2.zsh` | Metrics collection engine | ✅ Working |
| `scripts/server/websocket-server-v2.py` | Real-time data server | ✅ Working |
| `web/public/dashboard-realtime.html` | User dashboard interface | ✅ Working |
| `scripts/setup/start-realtime-monitoring.sh` | Startup script | ✅ Working |

### Previous Versions (Legacy)
- `scripts/daemon/monitoring-daemon.zsh` - Original (v1)
- `scripts/server/websocket-server.py` - Original (v1)

## 🔧 Configuration

### Monitoring Settings
Edit `scripts/daemon/monitoring-daemon-v2.zsh`:
```bash
COLLECTION_INTERVAL=3  # seconds between metric collection
```

### HTTP Server Port
Edit `scripts/setup/start-realtime-monitoring.sh`:
```bash
python3 -m http.server 8000  # Change 8000 to desired port
```

### WebSocket Port
Edit `scripts/server/websocket-server-v2.py`:
```python
WEBSOCKET_PORT = 8765  # Change to desired port
```

## 📦 Dependencies

### System Requirements
- macOS (tested on MacBook Pro)
- Python 3.13+
- zsh shell
- netstat (for network metrics)
- ps (for process monitoring)

### Python Packages
```bash
pip install websockets
```

## 📚 Learning Resources

See `/docs/guides/` for:
- QUICK-START.md - Getting started quickly
- REALTIME-MONITORING-GUIDE.md - Full monitoring setup guide
- DAILY-AUTOMATION-GUIDE.md - Automation examples

See `/docs/references/` for:
- IF_THEN_REFERENCE.md - Conditional syntax
- PIPES_REFERENCE.md - Command piping
- PROCESSES-SIGNALS-REFERENCE.md - Process management
- BEST_PRACTICES.md - Recommended patterns

## 🎯 Project Goals

✅ Learn zshell scripting
✅ Build real-time monitoring system
✅ Automate daily MacBook tasks
✅ Create interactive dashboards
✅ Master system administration

## 🚀 Future Enhancements

Potential improvements:
- [ ] Historical data storage (database)
- [ ] Network protocol breakdown (TCP/UDP/DNS stats)
- [ ] Disk I/O metrics
- [ ] Network geolocation tracking
- [ ] Automated alerting
- [ ] Performance benchmarking
- [ ] Mobile responsive dashboard
- [ ] Dark mode UI

## 📄 License

This project is for educational purposes.

---

**Last Updated:** October 10, 2026
**Status:** Production Ready ✅
