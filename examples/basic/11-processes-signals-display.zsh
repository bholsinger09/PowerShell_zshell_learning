#!/bin/zsh

# Processes, Signals, and Job Control Tutorial - Display Version
# Learn how to start, stop, and manage processes
# Usage: ./11-processes-signals-display.zsh [example_number or 'all']

# Setup colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Parse arguments
EXAMPLE=${1:-1}

show_example() {
    local num=$1
    local title=$2
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║ EXAMPLE $num: $title${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ============ EXAMPLE 1 ============
if [[ "$EXAMPLE" == "1" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "1" "Foreground vs Background processes"

cat << 'EOF'
FOREGROUND PROCESS:
  Command runs, shell waits for it to finish
  You can't type anything until it completes
  
BACKGROUND PROCESS:
  Command runs, shell returns immediately
  You can type new commands while it runs
  Syntax: command &

Let's see the difference:
EOF

echo ""
echo -e "${YELLOW}Foreground (shell waits):${NC}"
echo "Command: sleep 2; echo 'Done waiting'"
sleep 2
echo "Done waiting"

echo ""
echo -e "${YELLOW}Background (shell returns immediately):${NC}"
echo "Command: sleep 3 & echo 'Started background job'"
sleep 3 &
echo "Started background job"
wait

echo ""
echo -e "${BLUE}KEY DIFFERENCE:${NC}"
echo "Foreground:   shell blocked until done"
echo "Background:   shell returns, job runs separately"
fi

# ============ EXAMPLE 2 ============
if [[ "$EXAMPLE" == "2" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "2" "List running jobs"

cat << 'EOF'
The 'jobs' command shows all jobs in current shell.
A "job" is a process started from this shell.
EOF

echo ""
echo -e "${YELLOW}Start some background jobs:${NC}"
sleep 10 &
sleep 10 &
sleep 10 &

echo "Command: jobs"
echo ""
jobs

echo ""
echo -e "${BLUE}What you see:${NC}"
echo "  [1], [2], [3] = job numbers (not process IDs)"
echo "  Running = job is currently executing"
echo "  sleep 10 = the command"
fi

# ============ EXAMPLE 3 ============
if [[ "$EXAMPLE" == "3" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "3" "Bring background job to foreground"

cat << 'EOF'
Use 'fg' to bring a background job to foreground.
Now you can interact with it again.
Syntax: fg %job_number
EOF

echo ""
echo -e "${YELLOW}Start a background job:${NC}"
sleep 10 &
JOB_NUM=$(jobs -p | head -1)
echo "Started job with PID $JOB_NUM"

echo ""
echo -e "${YELLOW}Check it's in background:${NC}"
jobs

echo ""
echo -e "${YELLOW}Bring to foreground and interrupt:${NC}"
echo "We would run: fg %1"
echo "Then press Ctrl+C to stop it"
echo "For demo, just showing concept..."

# Clean up
kill $JOB_NUM 2>/dev/null
wait $JOB_NUM 2>/dev/null

echo ""
echo -e "${BLUE}fg = Foreground${NC}"
echo "Brings background job back to foreground"
fi

# ============ EXAMPLE 4 ============
if [[ "$EXAMPLE" == "4" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "4" "Suspend and resume background jobs"

cat << 'EOF'
'bg' resumes a suspended job in background.
'fg' brings it to foreground.

SUSPENDED JOB: Still exists but paused
BACKGROUND JOB: Running but you can't type to it
FOREGROUND JOB: Running and you can interact with it
EOF

echo ""
echo -e "${YELLOW}Start a background job:${NC}"
sleep 20 &
JOB=$!
echo "Background job started: PID $JOB"

echo ""
echo -e "${YELLOW}Check job status:${NC}"
jobs

echo ""
echo -e "${BLUE}PROCESS STATES:${NC}"
echo "Running   = Job is actively running"
echo "Stopped   = Job is paused (Ctrl+Z suspended it)"
echo "Done      = Job finished"
echo "Terminated= Job was killed"

# Clean up
kill $JOB 2>/dev/null
wait $JOB 2>/dev/null
fi

# ============ EXAMPLE 5 ============
if [[ "$EXAMPLE" == "5" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "5" "What is a signal?"

cat << 'EOF'
A SIGNAL is a message sent to a process.
Common signals:
  SIGTERM (15) = Terminate gracefully (default kill)
  SIGKILL (9)  = Force kill immediately (can't be caught)
  SIGINT  (2)  = Interrupt (Ctrl+C)
  SIGSTOP (19) = Suspend (Ctrl+Z)
  SIGCONT (18) = Resume

Process receives signal → reacts to it (or ignores it)
Different signals = different purposes
EOF

echo ""
echo -e "${YELLOW}Common signals table:${NC}"
cat << 'TABLE'
Signal  Number  Meaning              Can ignore?
──────  ──────  ──────────────────   ───────────
SIGHUP  1       Hangup               Yes
SIGINT  2       Interrupt (Ctrl+C)   Yes
SIGQUIT 3       Quit                 Yes
SIGKILL 9       Kill (force)         NO (always works!)
SIGTERM 15      Terminate            Yes
SIGSTOP 19      Stop (suspend)       NO
SIGCONT 18      Continue (resume)    No
TABLE

echo ""
echo -e "${BLUE}SIGKILL (9) is special:${NC}"
echo "It ALWAYS works - process can't ignore or catch it"
echo "Use SIGTERM first, SIGKILL only if necessary"
fi

# ============ EXAMPLE 6 ============
if [[ "$EXAMPLE" == "6" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "6" "Kill process with SIGTERM"

cat << 'EOF'
'kill' sends signal to process.
Default: SIGTERM (graceful termination)
Process can cleanup before exiting.

Syntax: kill PID
        kill -9 PID (SIGKILL - force)
EOF

echo ""
echo -e "${YELLOW}Start a background process:${NC}"
sleep 100 &
PID=$!
echo "Process started with PID: $PID"

echo ""
echo -e "${YELLOW}Verify it's running:${NC}"
ps -p $PID -o pid,cmd,stat

echo ""
echo -e "${YELLOW}Send SIGTERM (graceful stop):${NC}"
echo "Command: kill $PID"
kill $PID

sleep 1
echo ""
echo -e "${YELLOW}Check if it's gone:${NC}"
ps -p $PID -o pid,cmd,stat 2>&1 | tail -1

echo ""
echo -e "${BLUE}SIGTERM sent process terminated gracefully${NC}"
fi

# ============ EXAMPLE 7 ============
if [[ "$EXAMPLE" == "7" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "7" "SIGKILL for stubborn processes"

cat << 'EOF'
If SIGTERM doesn't work, use SIGKILL (-9).
This FORCES termination - process can't ignore it.
Use only when SIGTERM fails!

Syntax: kill -9 PID
EOF

echo ""
echo -e "${YELLOW}Start a background process:${NC}"
sleep 100 &
PID=$!
echo "Process started with PID: $PID"

echo ""
echo -e "${YELLOW}Send SIGKILL (force kill):${NC}"
echo "Command: kill -9 $PID"
kill -9 $PID

sleep 1
echo ""
echo -e "${YELLOW}Check if it's gone:${NC}"
ps -p $PID -o pid,cmd,stat 2>&1 | tail -1

echo ""
echo -e "${BLUE}Process forcefully terminated immediately${NC}"
fi

# ============ EXAMPLE 8 ============
if [[ "$EXAMPLE" == "8" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "8" "List processes (ps command)"

cat << 'EOF'
'ps' shows processes.
Many options for different views:
  ps aux     = All processes, detailed
  ps -p PID  = Specific process
  ps -u user = Processes by user
EOF

echo ""
echo -e "${YELLOW}Show all processes (truncated):${NC}"
ps aux | head -5

echo ""
echo -e "${YELLOW}Column meanings:${NC}"
cat << 'COLS'
USER     = Who owns the process
PID      = Process ID
%CPU     = CPU usage percentage
%MEM     = Memory usage percentage
VSZ      = Virtual memory size
RSS      = Physical memory size
STAT     = Process state (S=sleeping, R=running)
START    = When it started
TIME     = CPU time used
COMMAND  = The actual command
COLS

echo ""
echo -e "${YELLOW}Show only shell processes:${NC}"
ps aux | grep -i zsh | head -3
fi

# ============ EXAMPLE 9 ============
if [[ "$EXAMPLE" == "9" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "9" "Find processes by name (pgrep)"

cat << 'EOF'
'pgrep' finds processes by name.
Easier than 'ps' for searching.

Syntax: pgrep pattern     = Get PIDs
        pgrep -l pattern  = Get PIDs and names
        pgrep -u user     = Processes by user
EOF

echo ""
echo -e "${YELLOW}Find shell processes:${NC}"
echo "Command: pgrep -l zsh"
pgrep -l zsh | head -5

echo ""
echo -e "${YELLOW}Find all processes (count):${NC}"
TOTAL=$(pgrep -a . | wc -l)
echo "Total processes running: $TOTAL"

echo ""
echo -e "${BLUE}pgrep is faster than ps | grep${NC}"
echo "Good for scripts and automation"
fi

# ============ EXAMPLE 10 ============
if [[ "$EXAMPLE" == "10" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "10" "Kill processes by name (pkill)"

cat << 'EOF'
'pkill' kills processes by name pattern.
More convenient than kill PID.

Syntax: pkill pattern     = Kill all matching
        pkill -9 pattern  = Force kill
        pkill -u user     = Kill by user
EOF

echo ""
echo -e "${YELLOW}Example pattern:${NC}"
echo "Command: pkill firefox"
echo "Effect: All firefox processes terminated"

echo ""
echo -e "${YELLOW}Force kill:${NC}"
echo "Command: pkill -9 -f 'slow_process'"
echo "Effect: Force kill all matching processes"

echo ""
echo -e "${BLUE}WARNING: pkill matches names, be careful!${NC}"
echo "Example: 'pkill node' kills ALL node processes"
echo "Use specific patterns to avoid accidents"
fi

# ============ EXAMPLE 11 ============
if [[ "$EXAMPLE" == "11" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "11" "Real-time process monitoring (top)"

cat << 'EOF'
'top' shows live updating process list.
Sorted by CPU/memory usage by default.
Press 'q' to quit, 'k' to kill.

'htop' is enhanced version (install separately).
EOF

echo ""
echo -e "${YELLOW}Run 'top' in demo mode (quick snapshot):${NC}"
echo "Normal command: top"
echo "Press: q (quit), k (kill), M (sort by memory)"
echo ""
echo "For demo, showing 'ps aux' instead (static view):"
ps aux --sort=-%cpu | head -5

echo ""
echo -e "${BLUE}top shows:${NC}"
echo "  Real-time CPU and memory usage"
echo "  Sorted by most hungry processes"
echo "  System load average"
echo "  Total memory/swap usage"
fi

# ============ EXAMPLE 12 ============
if [[ "$EXAMPLE" == "12" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "12" "Real DevOps pattern: Process management script"

cat << 'EOF'
Combine everything into production pattern.
Check if process is running, restart if needed.
EOF

echo ""
echo -e "${YELLOW}Real DevOps monitoring pattern:${NC}"

cat > /tmp/monitor_app.sh << 'SCRIPT'
#!/bin/bash

APP_NAME="my_app"
APP_PID_FILE="/tmp/my_app.pid"

# Check if process is running
if [ -f "$APP_PID_FILE" ]; then
    PID=$(cat "$APP_PID_FILE")
    if ps -p $PID > /dev/null; then
        echo "✓ $APP_NAME is running (PID: $PID)"
    else
        echo "✗ $APP_NAME crashed! Restarting..."
        rm "$APP_PID_FILE"
        # Start the app
        nohup ./app > /dev/null 2>&1 &
        echo $! > "$APP_PID_FILE"
        echo "✓ Restarted (PID: $(cat $APP_PID_FILE))"
    fi
else
    echo "✗ $APP_NAME not running. Starting..."
    nohup ./app > /dev/null 2>&1 &
    echo $! > "$APP_PID_FILE"
    echo "✓ Started (PID: $(cat $APP_PID_FILE))"
fi

# Show memory usage
MEM=$(ps -p $(cat "$APP_PID_FILE") -o %mem= 2>/dev/null)
echo "Memory usage: ${MEM}%"
SCRIPT

echo "Script created: /tmp/monitor_app.sh"
cat /tmp/monitor_app.sh | head -20

echo ""
echo -e "${BLUE}This script:${NC}"
echo "  ✓ Checks if process is running"
echo "  ✓ Restarts if crashed"
echo "  ✓ Tracks with PID file"
echo "  ✓ Shows memory usage"
echo "  ✓ This is production-grade!"
fi

# ============ SUMMARY ============
if [[ "$EXAMPLE" == "summary" ]] || [[ "$EXAMPLE" == "all" ]]; then
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║ SUMMARY: Processes, Signals, and Job Control${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

cat << 'EOF'
KEY CONCEPTS:

1. Job Control (in shell)
   command &           Start in background
   jobs                List shell jobs
   fg %1               Bring to foreground
   bg %1               Resume in background
   Ctrl+Z              Suspend current job

2. Signals (messages to processes)
   SIGTERM (15)  = Graceful termination (default)
   SIGKILL (9)   = Force kill (can't be caught)
   SIGINT (2)    = Interrupt (Ctrl+C)
   SIGSTOP (19)  = Suspend (Ctrl+Z)
   SIGCONT (18)  = Resume

3. Process Management
   kill PID           Send SIGTERM to process
   kill -9 PID        Send SIGKILL (force)
   ps aux             List all processes
   ps -p PID          Show specific process
   pgrep name         Find process by name
   pkill name         Kill by name

4. Monitoring
   top                Live process view (CPU/memory)
   htop               Enhanced top
   ps aux --sort=-%cpu   Sort by CPU usage
   watch command      Run command repeatedly

5. Process Information
   PID = Process ID (unique number)
   PPID = Parent Process ID
   STAT = Process state (R=running, S=sleeping, Z=zombie)
   VSZ = Virtual memory size
   RSS = Physical memory used

6. Real Production Patterns
   - Check if process running (ps -p PID)
   - Restart if crashed
   - Track with PID files
   - Monitor CPU/memory
   - Send proper signals (TERM before KILL)
   - Handle zombie processes

COMMANDS USED:
   job control: command &, jobs, fg, bg
   signals: kill, kill -9, pkill, pkill -9
   listing: ps, ps aux, pgrep, pgrep -l
   monitoring: top, htop, watch
   info: ps -p PID, ps -u user, ps --sort

SIGNAL SEQUENCE (best practice):
   1. kill PID           (SIGTERM - graceful)
   2. wait 5 seconds
   3. if still running: kill -9 PID  (SIGKILL - force)

DevOps Pattern:
   Monitor process → Check if running → Restart if needed → Track PID
   This is how production systems stay up!
EOF
fi

echo ""
