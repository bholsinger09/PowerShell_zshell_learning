#!/bin/zsh

# Processes, Signals, and Job Control - Practice Challenges
# Real-world DevOps scenarios
# Usage: ./12-processes-signals-challenges.zsh [challenge_number]

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Parse arguments
CHALLENGE=${1:-all}

show_challenge() {
    local num=$1
    local title=$2
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║ CHALLENGE $num: $title${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_solution() {
    echo ""
    echo -e "${BLUE}✅ SOLUTION:${NC}"
    echo ""
}

# ============ CHALLENGE 1.1 ============
if [[ "$CHALLENGE" == "1.1" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "1.1" "Start and manage background jobs"

cat << 'EOF'
OBJECTIVE:
  Start multiple background jobs and manage them

TASK:
  1. Start 3 background sleep processes
  2. List all jobs
  3. Check their process IDs
  4. Find them with pgrep
  5. Kill them with pkill

COMMANDS YOU'LL USE:
  command &         Start in background
  jobs              List jobs
  pgrep pattern     Find by name
  pkill pattern     Kill by name

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
# Start 3 background jobs
sleep 100 &
sleep 100 &
sleep 100 &

# List them
jobs

# Find with pgrep
pgrep -l sleep

# Verify count
pgrep -c sleep
# Should show: 3

# Kill them all
pkill sleep

# Verify they're gone
sleep 1
pgrep -c sleep
# Should show: 0 (or no output)
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • & starts in background"
echo "  • jobs shows shell jobs"
echo "  • pgrep finds processes"
echo "  • pkill kills by name"
echo "  • These are fundamental DevOps tools"
fi

# ============ CHALLENGE 1.2 ============
if [[ "$CHALLENGE" == "1.2" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "1.2" "Signal progression: SIGTERM then SIGKILL"

cat << 'EOF'
OBJECTIVE:
  Practice proper signal sequence for process termination

TASK:
  1. Start a process
  2. Send SIGTERM first (graceful)
  3. Check if it stopped
  4. If still running, send SIGKILL
  5. Verify it's gone

PATTERN:
  1. kill PID          (SIGTERM)
  2. wait 2 seconds
  3. if still running: kill -9 PID  (SIGKILL)

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
# Start a process
sleep 100 &
PID=$!
echo "Process PID: $PID"

# Send SIGTERM (graceful)
echo "Sending SIGTERM..."
kill $PID
sleep 1

# Check if stopped
if ps -p $PID > /dev/null 2>&1; then
    echo "Still running, sending SIGKILL..."
    kill -9 $PID
    sleep 1
fi

# Verify it's gone
if ps -p $PID > /dev/null 2>&1; then
    echo "ERROR: Still running!"
else
    echo "✓ Process terminated"
fi
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • Best practice: SIGTERM first"
echo "  • Wait before SIGKILL"
echo "  • Check process status"
echo "  • This is production-safe pattern"
fi

# ============ CHALLENGE 2.1 ============
if [[ "$CHALLENGE" == "2.1" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "2.1" "Monitor and auto-restart a process"

cat << 'EOF'
OBJECTIVE:
  Build a monitoring script that restarts crashed processes

TASK:
  1. Create a monitoring script
  2. Start a process and track with PID file
  3. Stop the process manually
  4. Run monitor script
  5. Verify it detected and restarted it

PATTERN:
  - Save PID: echo $! > /tmp/app.pid
  - Check alive: ps -p $(cat /tmp/app.pid)
  - If dead, restart and update PID file

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
# Create monitoring script
cat > /tmp/monitor_demo.sh << 'SCRIPT'
#!/bin/bash
PIDFILE="/tmp/demo.pid"

if [ -f "$PIDFILE" ]; then
    PID=$(cat "$PIDFILE")
    if ps -p $PID > /dev/null 2>&1; then
        echo "✓ Process running (PID: $PID)"
    else
        echo "✗ Process dead! Restarting..."
        rm "$PIDFILE"
        sleep 100 &
        echo $! > "$PIDFILE"
        echo "✓ Restarted (PID: $(cat $PIDFILE))"
    fi
else
    echo "Starting process..."
    sleep 100 &
    echo $! > "$PIDFILE"
    echo "✓ Started (PID: $(cat $PIDFILE))"
fi
SCRIPT

chmod +x /tmp/monitor_demo.sh

# Run it first time (starts process)
/tmp/monitor_demo.sh

# Kill the process
PID=$(cat /tmp/demo.pid 2>/dev/null)
kill $PID 2>/dev/null
sleep 1

# Run monitor again (detects death and restarts)
/tmp/monitor_demo.sh

# Cleanup
pkill -f 'sleep 100'
rm -f /tmp/demo.pid /tmp/monitor_demo.sh
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • How production monitoring works"
echo "  • PID files for tracking"
echo "  • Automatic restart on failure"
echo "  • This pattern keeps apps running 24/7"
fi

# ============ CHALLENGE 2.2 ============
if [[ "$CHALLENGE" == "2.2" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "2.2" "Process monitoring with resource limits"

cat << 'EOF'
OBJECTIVE:
  Monitor process and check resource usage

TASK:
  1. Start a process
  2. Get its PID
  3. Check memory usage with ps
  4. Check CPU usage
  5. Sort processes by memory usage
  6. Kill if using too much

COMMANDS:
  ps -p PID -o %mem     Get memory percentage
  ps aux --sort=-%mem   Sort by memory
  kill PID if too high

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
# Start a process
sleep 100 &
PID=$!

# Get its info
echo "Process information:"
ps -p $PID -o pid,cmd,%cpu,%mem,vsz,rss

# Get just memory
MEM=$(ps -p $PID -o %mem=)
echo "Memory usage: $MEM%"

# Check CPU
CPU=$(ps -p $PID -o %cpu=)
echo "CPU usage: $CPU%"

# Show top memory users
echo ""
echo "Top 3 memory users:"
ps aux --sort=-%mem | head -4

# Check and kill if over threshold
THRESHOLD=50
if (( $(echo "$MEM > $THRESHOLD" | bc -l) )); then
    echo "Using too much memory! Killing..."
    kill $PID
else
    echo "Memory usage OK"
    kill $PID
fi
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • Monitor resource usage"
echo "  • ps columns: %cpu, %mem, vsz, rss"
echo "  • Sort by resource usage"
echo "  • Kill runaway processes"
echo "  • Automated resource protection"
fi

# ============ CHALLENGE 3.1 ============
if [[ "$CHALLENGE" == "3.1" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "3.1" "Real DevOps: Graceful shutdown script"

cat << 'EOF'
OBJECTIVE:
  Create a safe shutdown script using proper signal sequence

TASK:
  1. Create a shutdown script that:
     - Takes process name as argument
     - Sends SIGTERM first
     - Waits 5 seconds
     - If still running, sends SIGKILL
     - Reports final status
  2. Test with multiple processes

SAFETY PATTERN:
  ✓ SIGTERM first (allows cleanup)
  ✓ Wait period (gives time to stop)
  ✓ Check status (verify stopped)
  ✓ SIGKILL if needed (force stop)

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
# Create shutdown script
cat > /tmp/graceful_shutdown.sh << 'SCRIPT'
#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

PROCESS=$1
TIMEOUT=5

echo "Shutting down: $PROCESS"

# Find process
PID=$(pgrep -f "$PROCESS" | head -1)

if [ -z "$PID" ]; then
    echo "Process not found"
    exit 1
fi

echo "Found PID: $PID"

# Send SIGTERM (graceful)
echo "Sending SIGTERM..."
kill $PID 2>/dev/null

# Wait for graceful shutdown
echo "Waiting $TIMEOUT seconds..."
for i in $(seq 1 $TIMEOUT); do
    if ! ps -p $PID > /dev/null 2>&1; then
        echo "✓ Process stopped gracefully"
        exit 0
    fi
    echo -n "."
    sleep 1
done

echo ""
# Process still running, use SIGKILL
echo "✗ Process still running! Using SIGKILL..."
kill -9 $PID 2>/dev/null

sleep 1
if ! ps -p $PID > /dev/null 2>&1; then
    echo "✓ Process force killed"
else
    echo "✗ ERROR: Could not kill process"
    exit 1
fi
SCRIPT

chmod +x /tmp/graceful_shutdown.sh

# Test it
sleep 100 &
sleep 100 &

echo "Starting processes..."
sleep 1

echo ""
echo "Shutting down sleep processes..."
/tmp/graceful_shutdown.sh sleep

# Cleanup
pkill -9 -f 'sleep 100' 2>/dev/null
rm -f /tmp/graceful_shutdown.sh
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • Production-grade shutdown script"
echo "  • Graceful termination with timeout"
echo "  • Force kill as fallback"
echo "  • Error handling"
echo "  • This is what production uses!"
fi

# ============ CHALLENGE 3.2 ============
if [[ "$CHALLENGE" == "3.2" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "3.2" "Real DevOps: Service manager script"

cat << 'EOF'
OBJECTIVE:
  Build a complete service manager script
  (start, stop, restart, status)

TASK:
  Create a script that:
  1. start   - Start the service
  2. stop    - Stop gracefully with timeout
  3. restart - Stop then start
  4. status  - Show if running
  5. kill    - Force kill if needed

COMMANDS:
  usage: ./service.sh {start|stop|restart|status}

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
# Create service manager
cat > /tmp/service_manager.sh << 'SCRIPT'
#!/bin/bash

SERVICE="test_service"
PIDFILE="/tmp/${SERVICE}.pid"

start() {
    if [ -f "$PIDFILE" ]; then
        PID=$(cat "$PIDFILE")
        if ps -p $PID > /dev/null 2>&1; then
            echo "✓ Already running (PID: $PID)"
            return
        fi
    fi
    echo "Starting $SERVICE..."
    sleep 100 &
    echo $! > "$PIDFILE"
    echo "✓ Started (PID: $(cat $PIDFILE))"
}

stop() {
    if [ ! -f "$PIDFILE" ]; then
        echo "✗ Not running"
        return
    fi
    PID=$(cat "$PIDFILE")
    echo "Stopping $SERVICE (PID: $PID)..."
    kill $PID 2>/dev/null
    sleep 2
    if ps -p $PID > /dev/null 2>&1; then
        echo "Force killing..."
        kill -9 $PID 2>/dev/null
    fi
    rm -f "$PIDFILE"
    echo "✓ Stopped"
}

status() {
    if [ -f "$PIDFILE" ]; then
        PID=$(cat "$PIDFILE")
        if ps -p $PID > /dev/null 2>&1; then
            echo "✓ Running (PID: $PID)"
        else
            echo "✗ Dead (PID file exists but process gone)"
        fi
    else
        echo "✗ Not running"
    fi
}

restart() {
    stop
    sleep 1
    start
}

case "$1" in
    start)   start ;;
    stop)    stop ;;
    restart) restart ;;
    status)  status ;;
    *)       echo "Usage: $0 {start|stop|restart|status}" ;;
esac
SCRIPT

chmod +x /tmp/service_manager.sh

# Test all commands
echo "Testing service manager:"
echo ""

echo "1. Status (not running):"
/tmp/service_manager.sh status

echo ""
echo "2. Start service:"
/tmp/service_manager.sh start

echo ""
echo "3. Status (running):"
/tmp/service_manager.sh status

echo ""
echo "4. Stop service:"
/tmp/service_manager.sh stop

echo ""
echo "5. Status (stopped):"
/tmp/service_manager.sh status

# Cleanup
pkill -f 'sleep 100'
rm -f /tmp/service_manager.sh /tmp/test_service.pid
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • Complete service management"
echo "  • start/stop/restart/status commands"
echo "  • Real production pattern"
echo "  • Used by systemd, supervisord, etc"
echo "  • Enterprise-grade automation"
fi

# ============ SUMMARY ============
if [[ "$CHALLENGE" == "all" ]]; then
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║ ALL CHALLENGES COMPLETE! 🎉${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "You've learned:"
echo "  ✅ Job control (background, foreground)"
echo "  ✅ Signal management (SIGTERM, SIGKILL)"
echo "  ✅ Process monitoring and restart"
echo "  ✅ Resource management"
echo "  ✅ Graceful shutdown patterns"
echo "  ✅ Complete service management"
echo ""
fi

echo ""
