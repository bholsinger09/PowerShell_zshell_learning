# 🔧 Processes, Signals, and Job Control Reference

## Overview

Managing processes is **essential** for DevOps and system administration. You need to:
- Start and stop applications
- Handle failures and restarts
- Monitor resource usage
- Control multiple services

---

## Job Control (In Your Shell)

### Starting Processes

```bash
# FOREGROUND (shell waits)
command argument        # Shell blocked until done

# BACKGROUND (shell returns immediately)
command argument &      # Shell ready for new commands
```

### Examples

```bash
# Foreground: shell waits
sleep 10                # Shell waits 10 seconds

# Background: shell returns immediately
sleep 10 &              # Shell returns right away
# Output: [1] 12345

# You can type new commands while it runs
ls
cd /tmp
pwd
# Job still running in background!
```

### List Background Jobs

```bash
jobs                    # List all background jobs in current shell
jobs -l                 # With process IDs
jobs -r                 # Running jobs only
jobs -s                 # Stopped jobs only
```

### Example Output

```bash
$ jobs -l
[1] - 12345 Running    sleep 100 &
[2] + 12346 Running    sleep 100 &
[3] - 12347 Stopped    process
```

### Bring to Foreground

```bash
fg                      # Resume most recent background job
fg %1                   # Resume job number 1
fg %2                   # Resume job number 2
```

### Suspend Current Job

```bash
Ctrl+Z                  # Suspends current foreground job
```

### Resume in Background

```bash
bg                      # Resume most recent stopped job
bg %1                   # Resume job 1 in background
```

---

## Signals

A **signal** is a message sent to a process telling it what to do.

### Common Signals

| Signal | Number | Name | Purpose | Catchable? |
|--------|--------|------|---------|-----------|
| SIGTERM | 15 | Terminate | Graceful stop | Yes |
| SIGKILL | 9 | Kill | Force stop | **NO** |
| SIGINT | 2 | Interrupt | Ctrl+C | Yes |
| SIGSTOP | 19 | Stop | Pause (Ctrl+Z) | **NO** |
| SIGCONT | 18 | Continue | Resume | No |
| SIGHUP | 1 | Hangup | Connection lost | Yes |
| SIGQUIT | 3 | Quit | Ctrl+\ | Yes |

### Key Differences

**SIGTERM (15)** - Graceful
- Process receives signal
- Can cleanup (close files, save state)
- Can ignore signal
- **Use first!**

**SIGKILL (9)** - Force
- Immediately terminates
- Process can't catch or ignore
- **ALWAYS works**
- No cleanup possible
- **Use only if SIGTERM fails**

### Sending Signals

```bash
kill PID                # Send SIGTERM (default, graceful)
kill -15 PID            # Explicit SIGTERM
kill -9 PID             # SIGKILL (force)
kill -l                 # List all signal numbers
```

### Best Practice Sequence

```bash
# Step 1: Try graceful termination
kill $PID               # SIGTERM - allows cleanup
sleep 5                 # Wait 5 seconds

# Step 2: Check if still running
if ps -p $PID > /dev/null 2>&1; then
    # Step 3: Force kill if necessary
    kill -9 $PID        # SIGKILL
fi
```

---

## Process Management Commands

### List Processes

```bash
ps                      # Current shell processes only
ps aux                  # All processes, detailed
ps -p PID               # Specific process
ps -u username          # By user
ps -e -o pid,cmd        # Custom columns
```

### Sorting Processes

```bash
ps aux --sort=%cpu      # By CPU usage
ps aux --sort=-%cpu     # Descending CPU
ps aux --sort=%mem      # By memory
ps aux --sort=-%mem     # Descending memory
```

### ps Columns Explained

```
USER       = Process owner
PID        = Process ID (unique)
%CPU       = CPU usage percentage
%MEM       = Memory usage percentage
VSZ        = Virtual memory size (KB)
RSS        = Resident set size (physical memory, KB)
STAT       = State (R=running, S=sleeping, Z=zombie, T=stopped)
START      = When it started
TIME       = CPU time used
COMMAND    = The actual command
```

### Find by Name (pgrep)

```bash
pgrep sleep             # Get PIDs of processes named "sleep"
pgrep -l sleep          # With names
pgrep -c sleep          # Count matching processes
pgrep -u user           # By user
pgrep -f 'python app.py'  # By full command
```

### Kill by Name (pkill)

```bash
pkill sleep             # Kill all "sleep" processes (SIGTERM)
pkill -9 sleep          # Force kill all "sleep" (SIGKILL)
pkill -u user app       # Kill user's "app" processes
```

⚠️ **Warning:** `pkill` uses pattern matching. Be specific to avoid killing unintended processes!

---

## Process States

```
R  = Running          (actively using CPU)
S  = Sleeping         (waiting for something)
D  = Disk sleep       (uninterruptible, can't be woken)
Z  = Zombie           (exited but parent didn't clean up)
T  = Stopped          (suspended via Ctrl+Z or SIGSTOP)
W  = Paging           (swapped out to disk)
X  = Dead             (being cleaned up)
```

### Zombie Processes

A zombie is a process that:
- Finished executing
- Parent process didn't read exit status
- Still occupies an entry in process table

**How to fix:**
```bash
# Find zombie
ps aux | grep Z

# Kill parent (parent will clean up zombies)
kill PPID

# Or find parent and kill it
kill $(ps -o ppid= -p ZOMBIE_PID)
```

---

## Real-World Patterns

### Pattern 1: Track Process with PID File

```bash
#!/bin/bash

APP_NAME="my_app"
PIDFILE="/var/run/my_app.pid"

# Start and save PID
./$APP_NAME &
echo $! > $PIDFILE

# Later, check if running
if [ -f $PIDFILE ]; then
    PID=$(cat $PIDFILE)
    if ps -p $PID > /dev/null 2>&1; then
        echo "Running (PID: $PID)"
    else
        echo "Not running"
        rm $PIDFILE
    fi
fi

# Stop
PID=$(cat $PIDFILE)
kill $PID
rm $PIDFILE
```

### Pattern 2: Auto-Restart on Crash

```bash
#!/bin/bash

PIDFILE="/tmp/app.pid"
APP="./my_app"

while true; do
    if [ ! -f "$PIDFILE" ] || ! ps -p $(cat $PIDFILE) > /dev/null 2>&1; then
        echo "$(date): Starting app..."
        $APP &
        echo $! > $PIDFILE
    fi
    sleep 5  # Check every 5 seconds
done
```

### Pattern 3: Graceful Shutdown

```bash
#!/bin/bash

PIDFILE="/tmp/app.pid"
TIMEOUT=10

if [ -f "$PIDFILE" ]; then
    PID=$(cat $PIDFILE)
    
    echo "Stopping PID $PID..."
    kill $PID
    
    # Wait for graceful shutdown
    ELAPSED=0
    while ps -p $PID > /dev/null 2>&1 && [ $ELAPSED -lt $TIMEOUT ]; do
        sleep 1
        ELAPSED=$((ELAPSED + 1))
    done
    
    # Force kill if still running
    if ps -p $PID > /dev/null 2>&1; then
        echo "Force killing..."
        kill -9 $PID
    fi
    
    rm -f $PIDFILE
fi
```

### Pattern 4: Service Manager

```bash
#!/bin/bash

SERVICE="my_service"
PIDFILE="/tmp/$SERVICE.pid"
COMMAND="./server"

start() {
    if [ -f $PIDFILE ] && ps -p $(cat $PIDFILE) > /dev/null; then
        echo "Already running"
    else
        $COMMAND &
        echo $! > $PIDFILE
        echo "Started (PID: $(cat $PIDFILE))"
    fi
}

stop() {
    if [ -f $PIDFILE ]; then
        kill $(cat $PIDFILE)
        rm $PIDFILE
        echo "Stopped"
    else
        echo "Not running"
    fi
}

status() {
    if [ -f $PIDFILE ] && ps -p $(cat $PIDFILE) > /dev/null; then
        echo "Running (PID: $(cat $PIDFILE))"
    else
        echo "Not running"
    fi
}

case "$1" in
    start)   start ;;
    stop)    stop ;;
    restart) stop; start ;;
    status)  status ;;
    *)       echo "Usage: $0 {start|stop|restart|status}" ;;
esac
```

---

## Monitoring Commands

### Live Process Monitor (top)

```bash
top                 # Interactive live view
# Press:
#   q = quit
#   k = kill process
#   M = sort by memory
#   P = sort by CPU
#   u = filter by user
#   N = by PID
```

### Enhanced Monitor (htop - if installed)

```bash
htop                # Better than top
# Similar controls as top, more user-friendly
```

### Watch Command Repeatedly

```bash
watch ps aux                # Run ps every 2 seconds
watch -n 1 'ps aux'         # Every 1 second
watch -n 5 'df -h'          # Monitor disk every 5 seconds
```

### One-Time Process Info

```bash
ps -p 1234 -o pid,cmd,%cpu,%mem,vsz,rss
# Shows specific columns for PID 1234

# Output:
# PID CMD             %CPU %MEM    VSZ   RSS
# 1234 ./app          5.2   1.5  102400  15360
```

---

## DevOps Checklist

### When Starting a Service

- [ ] Save PID to file for tracking
- [ ] Log startup message with timestamp
- [ ] Check prerequisites (config files, ports)
- [ ] Verify process started successfully
- [ ] Set up monitoring/restart mechanism

### When Stopping a Service

- [ ] Send SIGTERM first (graceful)
- [ ] Wait 5-10 seconds for shutdown
- [ ] Send SIGKILL only if needed
- [ ] Remove PID file
- [ ] Log shutdown message
- [ ] Verify process is gone

### For Monitoring

- [ ] Check process regularly (every 5-10 seconds)
- [ ] Restart if crashed
- [ ] Log crash/restart events
- [ ] Monitor resource usage
- [ ] Alert if using too much memory/CPU

### Process Health Checks

```bash
#!/bin/bash

PIDFILE="/tmp/app.pid"
MAX_MEM=50  # 50% memory limit

if [ -f $PIDFILE ]; then
    PID=$(cat $PIDFILE)
    
    # Check if running
    if ! ps -p $PID > /dev/null 2>&1; then
        echo "Process dead, restarting..."
        rm $PIDFILE
        ./app &
        echo $! > $PIDFILE
    fi
    
    # Check memory usage
    MEM=$(ps -p $PID -o %mem=)
    if (( $(echo "$MEM > $MAX_MEM" | bc -l) )); then
        echo "Memory too high ($MEM%), restarting..."
        kill $PID
        sleep 1
        ./app &
        echo $! > $PIDFILE
    fi
fi
```

---

## Common Scenarios

### Kill All Node.js Processes

```bash
pkill -f node           # SIGTERM (graceful)
sleep 5
pkill -9 -f node        # SIGKILL if needed
```

### Stop All Processes by User

```bash
pkill -u username       # Graceful
pkill -9 -u username    # Force
```

### Monitor CPU-Heavy Processes

```bash
ps aux --sort=-%cpu | head -10
```

### Monitor Memory-Heavy Processes

```bash
ps aux --sort=-%mem | head -10
```

### Find Process Using Port

```bash
lsof -i :3000           # Find process on port 3000
kill $(lsof -ti :3000)  # Kill it
```

### Restart Service Safely

```bash
#!/bin/bash
SERVICE="my_app"
PIDFILE="/tmp/$SERVICE.pid"

# Graceful restart
kill $(cat $PIDFILE)
sleep 2

if [ -f $PIDFILE ]; then
    rm $PIDFILE
fi

./$SERVICE &
echo $! > $PIDFILE
```

---

## Command Reference

### Job Control
```bash
command &               Start in background
jobs                    List jobs
fg %1                   Bring to foreground
bg %1                   Resume in background
Ctrl+Z                  Suspend current job
```

### Signals
```bash
kill PID                SIGTERM (graceful)
kill -9 PID             SIGKILL (force)
pkill pattern           Kill by name
kill -l                 List signals
```

### Finding Processes
```bash
ps aux                  List all
ps -p PID               Specific process
pgrep name              Find by name
pgrep -l name           With names
pgrep -c name           Count
```

### Monitoring
```bash
top                     Live monitor
htop                    Enhanced monitor
ps aux --sort=%cpu      By CPU
ps aux --sort=%mem      By memory
watch command           Run repeatedly
```

### Process Info
```bash
ps -p PID -o %mem=      Memory percentage
ps -p PID -o vsz,rss    Memory sizes
ps -p PID -o %cpu=      CPU percentage
```

---

## Summary

**Job Control:**
- Use `&` to run in background
- Use `jobs` to list them
- Use `fg` to bring back to foreground

**Signals:**
- SIGTERM first (graceful)
- SIGKILL as fallback (force)
- Always try TERM before KILL

**Process Management:**
- `ps` to list
- `pgrep` to find by name
- `pkill` to kill by name

**Production Patterns:**
- Save PID for tracking
- Auto-restart on crash
- Graceful shutdown with timeout
- Monitor and restart if needed

**Remember:**
- ✓ Always use SIGTERM first
- ✓ Wait before SIGKILL
- ✓ Track with PID files
- ✓ Auto-restart on crash
- ✓ Monitor resource usage
- ✓ This keeps apps running 24/7!
