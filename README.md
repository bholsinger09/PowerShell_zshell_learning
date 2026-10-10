# Zshell Learning Project & Real-Time MacBook Monitoring System

A comprehensive collection of zshell learning materials, automation scripts, and a full-featured real-time MacBook monitoring system with WebSocket dashboard.

## 🎯 Project Overview

### Learning Component
Master zshell scripting from basics to advanced DevOps automation patterns.

### Monitoring Component (Production Ready)
Real-time MacBook Pro system monitoring with live dashboard:
- **CPU, Memory, Disk, Battery** monitoring
- **Network Traffic** detection (download/upload Mbps)
- **Active Connections** tracking
- **Process Monitoring** (top 5 by CPU)
- **Auto-refresh** dashboard (2-minute intervals)
- **WebSocket** real-time updates

## 📁 Project Structure

See [`PROJECT-STRUCTURE.md`](PROJECT-STRUCTURE.md) for detailed organization.

```
.
├── README.md                   # This file
├── PROJECT-STRUCTURE.md        # Complete directory guide
│
├── docs/                       # Documentation
│   ├── guides/                 # Learning guides & how-tos
│   ├── references/             # Technical reference materials
│   ├── reports/                # Test reports & session logs
│   └── *.md                    # Setup & platform guides
│
├── scripts/                    # Executable scripts
│   ├── daemon/                 # Monitoring daemons
│   ├── server/                 # WebSocket & HTTP servers
│   ├── utilities/              # Helper utilities
│   └── setup/                  # Installation & startup scripts
│
├── web/                        # Web applications
│   └── public/                 # Dashboard HTML & assets
│
├── examples/                   # Learning examples
│   ├── basic/                  # Foundational concepts
│   ├── intermediate/           # Intermediate techniques
│   └── advanced/               # Advanced patterns
│
├── config/                     # Configuration files
│   └── startup-launchd/        # Launch daemon configs
│
└── monitoring/                 # Monitoring configuration
    └── config/                 # Settings & options
```

## 🚀 Quick Start - Real-Time Monitoring

### 1. Start the Monitoring System
```bash
cd ~/Documents/Zshell_Project
./scripts/setup/start-realtime-monitoring.sh
```

This starts:
- **Monitoring Daemon** - Collects metrics every 3 seconds
- **WebSocket Server** - Broadcasts on `ws://localhost:8765`
- **HTTP Server** - Serves dashboard on `http://localhost:8000`

### 2. Open Dashboard
```
http://localhost:8000/web/public/dashboard-realtime.html
```

### 3. Keep Browsing
Open additional browser tabs to generate network traffic. Watch the real-time metrics update:
- Network Download/Upload speeds
- Active connection count
- Live system charts

## 📊 Real-Time Monitoring Features

### Metrics Dashboard
| Metric | Range | Update Interval |
|--------|-------|-----------------|
| CPU Usage | 0-100% | 3 seconds |
| Memory | 0-100% | 3 seconds |
| Disk | 0-100% | 3 seconds |
| Battery | 0-100% | 3 seconds |
| Network Down | 0-100+ Mbps | 3 seconds |
| Network Up | 0-100+ Mbps | 3 seconds |
| Connections | 0-100+ | 3 seconds |

### Live Charts
- Memory Usage over 2 minutes
- Disk Usage over 2 minutes
- CPU % over 2 minutes
- CPU Load over 2 minutes
- Battery Level over 2 minutes
- Network (Download & Upload) over 2 minutes

### Additional Data
- Top 5 CPU Processes
- Active TCP Connections (top 10)
- System Uptime
- Auto-refresh every 2 minutes

## 🎓 Learning Path

### Beginner
1. Start with [`docs/guides/QUICK-START.md`](docs/guides/QUICK-START.md)
2. Review [`examples/basic/`](examples/basic/) - Variables, conditionals, pipes
3. Read [`docs/references/`](docs/references/) - Core syntax reference

### Intermediate
1. Explore [`examples/intermediate/`](examples/intermediate/) - More complex patterns
2. Study the monitoring daemon: [`scripts/daemon/monitoring-daemon-v2.zsh`](scripts/daemon/monitoring-daemon-v2.zsh)
3. Review [`docs/guides/DAILY-AUTOMATION-GUIDE.md`](docs/guides/DAILY-AUTOMATION-GUIDE.md)

### Advanced
1. Analyze [`scripts/daemon/monitoring-daemon-v2.zsh`](scripts/daemon/monitoring-daemon-v2.zsh) - Full system
2. Study [`scripts/server/websocket-server-v2.py`](scripts/server/websocket-server-v2.py) - WebSocket architecture
3. Review [`docs/guides/REALTIME-MONITORING-GUIDE.md`](docs/guides/REALTIME-MONITORING-GUIDE.md)
4. Explore [`examples/advanced/`](examples/advanced/) - Advanced patterns

## 📚 Key Documentation

### Guides
- [Quick Start](docs/guides/QUICK-START.md) - Get started in 5 minutes
- [Real-Time Monitoring](docs/guides/REALTIME-MONITORING-GUIDE.md) - Full monitoring guide
- [Daily Automation](docs/guides/DAILY-AUTOMATION-GUIDE.md) - Task automation

### References
- [If-Then Conditionals](docs/references/IF_THEN_REFERENCE.md)
- [Pipes & Command Chaining](docs/references/PIPES_REFERENCE.md)
- [Process Management](docs/references/PROCESSES-SIGNALS-REFERENCE.md)
- [Environment Variables](docs/references/ENVIRONMENT-VARIABLES-REFERENCE.md)
- [Best Practices](docs/references/BEST_PRACTICES.md)

## 🔧 Requirements

### System
- macOS (tested on MacBook Pro)
- Zshell (zsh) - default on modern macOS
- Python 3.13+ (for WebSocket server)

### Python Packages
```bash
pip install websockets
```

### Unix Tools (built-in)
- netstat - Network statistics
- ps - Process monitoring
- top - System metrics
- vm_stat - Virtual memory
- pmset - Power management
- df - Disk usage

## 🔑 Key Files

### Essential for Monitoring
| File | Purpose | Location |
|------|---------|----------|
| monitoring-daemon-v2.zsh | Metrics engine | `scripts/daemon/` |
| websocket-server-v2.py | Real-time server | `scripts/server/` |
| dashboard-realtime.html | User interface | `web/public/` |
| start-realtime-monitoring.sh | Startup script | `scripts/setup/` |

### Learning Examples
- Variables: `examples/basic/02-variables-and-types.zsh`
- Conditionals: `examples/basic/04-if-then-conditionals.zsh`
- Pipes: `examples/basic/05-pipes-and-command-chaining.zsh`
- Processes: `examples/basic/11-processes-signals-display.zsh`

## 🎯 Goals Accomplished

✅ Real-time system monitoring
✅ Live network traffic detection
✅ WebSocket real-time streaming
✅ Interactive web dashboard
✅ Zshell scripting mastery
✅ System automation
✅ DevOps practices

## 🚀 Future Enhancements

- [ ] Database storage (historical data)
- [ ] Network protocol breakdown
- [ ] Disk I/O metrics
- [ ] Automated alerting system
- [ ] Performance benchmarking
- [ ] Mobile responsive UI
- [ ] Dark mode theme

## 📝 Notes

- Always test scripts in safe environments first
- Monitoring system is production-ready for macOS
- Dashboard auto-refreshes every 2 minutes
- All metrics update every 3 seconds for accuracy

---

**Project Status:** Production Ready ✅
**Last Updated:** October 10, 2026
**Author:** Zshell Learning Project
