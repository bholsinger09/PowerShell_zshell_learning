#!/bin/zsh

# Interactive Processes, Signals, and Job Control Tutorial
# Learn by doing: Start, stop, and manage processes
# Usage: ./11-processes-signals-interactive.zsh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Function to pause
wait_for_user() {
    echo ""
    echo -e "${YELLOW}Press ENTER to continue...${NC}"
    read -r
}

# Function to show explanation
explain() {
    local title="$1"
    local content="$2"
    
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} $title"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "$content"
}

# Function to show and execute
show_and_try() {
    local description="$1"
    local command="$2"
    
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}$description${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Command:${NC}"
    echo -e "${GREEN}$command${NC}"
    echo ""
    echo -e "${YELLOW}Press ENTER to see the result...${NC}"
    read -r
    echo ""
    echo -e "${CYAN}Output:${NC}"
    eval "$command" 2>/dev/null || echo "(Command executed)"
}

# Main tutorial
clear

echo -e "${GREEN}"
cat << 'EOF'
╔════════════════════════════════════════════════════════╗
║                                                        ║
║   INTERACTIVE PROCESSES & SIGNALS TUTORIAL             ║
║   Start, stop, and manage running processes           ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "${YELLOW}This is CRITICAL for DevOps automation!${NC}"
echo "How to start processes, stop them gracefully, and restart them."
echo "This is how production systems manage applications."
echo ""
wait_for_user

# ============ EXAMPLE 1 ============
explain "EXAMPLE 1: Foreground vs Background" \
"A FOREGROUND process blocks your shell.
You can't type anything until it finishes.

A BACKGROUND process runs while shell is ready.
You can type new commands immediately.

Use: command & (ampersand at end starts in background)"

show_and_try "Run a slow command in FOREGROUND:" \
"echo 'Starting 2-second sleep...' && sleep 2 && echo 'Done'"

wait_for_user

show_and_try "Run same in BACKGROUND (notice shell returns immediately):" \
"echo 'Starting sleep...' && (sleep 2 & echo \"Process ID: \$!\") && echo 'Shell ready again!'"

wait_for_user

explain "WHAT JUST HAPPENED:" \
"Foreground: Shell waited 2 seconds
Background: Shell returned immediately

The & (ampersand) is the key!
  sleep 100 = waits 100 seconds (blocks shell)
  sleep 100 & = runs in background (shell ready)"

wait_for_user

# ============ EXAMPLE 2 ============
explain "EXAMPLE 2: Start a background process and check status" \
"Start a background process and list all jobs."

show_and_try "Start three background jobs:" \
"sleep 100 & sleep 100 & sleep 100 & echo 'Jobs started' && sleep 1"

wait_for_user

show_and_try "List all background jobs:" \
"jobs"

wait_for_user

explain "WHAT YOU SEE:" \
"[1] Running    sleep 100
[2] Running    sleep 100  
[3] Running    sleep 100

The numbers [1], [2], [3] are JOB NUMBERS (not process IDs!)
'Running' means they're currently executing
All three 'sleep 100' commands are running simultaneously"

wait_for_user

# ============ EXAMPLE 3 ============
explain "EXAMPLE 3: Bring background job to foreground" \
"Use 'fg %1' to bring job number 1 to foreground."

show_and_try "Check current jobs:" \
"jobs -l"

wait_for_user

explain "JOBS OUTPUT EXPLAINED:" \
"[1] + Running   sleep 100 &
 ^    ^         ^
 |    |         command
 |    status (Running/Stopped)
 job number

The + means it's the 'current' job
You can bring it to foreground with: fg %1"

wait_for_user

# ============ EXAMPLE 4 ============
explain "EXAMPLE 4: Understanding Signals" \
"A SIGNAL is a message sent to a process.

Common signals:
  SIGTERM (15) = Stop gracefully (default)
  SIGKILL (9)  = FORCE stop (can't be ignored)
  SIGINT  (2)  = Interrupt (Ctrl+C)
  SIGSTOP (19) = Pause (Ctrl+Z)

Different signals, different purposes!"

show_and_try "Show available signals:" \
"kill -l | head -15"

wait_for_user

explain "SIGNAL MEANINGS:" \
"SIGTERM = Please stop (process can cleanup)
SIGKILL = Stop NOW (can't be caught or ignored)
SIGINT = Interrupt (same as Ctrl+C)
SIGSTOP = Pause execution
SIGCONT = Resume execution

Best practice:
  1. Send SIGTERM first (graceful)
  2. Wait a few seconds
  3. If still running, send SIGKILL (force)"

wait_for_user

# ============ EXAMPLE 5 ============
explain "EXAMPLE 5: Kill a process with SIGTERM" \
"Start a process, then gracefully stop it with kill."

show_and_try "Start a background process:" \
"sleep 100 & echo \"Started sleep process\""

wait_for_user

show_and_try "List all running processes:" \
"ps aux | grep sleep | grep -v grep"

wait_for_user

explain "PROCESS INFORMATION:" \
"You can see the process in the list.
The STAT column shows state (S=sleeping, R=running, Z=zombie)
We can now send it a signal."

# Find the sleep process and kill it
sleep_pid=$(pgrep -f 'sleep 100' | head -1)
if [ -n "$sleep_pid" ]; then
    show_and_try "Send SIGTERM (graceful stop):" \
"kill $sleep_pid && echo 'SIGTERM sent' && sleep 1"

    wait_for_user

    show_and_try "Check if process stopped:" \
"ps -p $sleep_pid 2>&1 | grep -q 'sleep' || echo 'Process terminated'"

    wait_for_user
fi

explain "GRACEFUL TERMINATION:" \
"SIGTERM allows process to:
  - Close files
  - Save state
  - Cleanup connections
  - Exit cleanly

Process RECEIVES signal and chooses to quit.
This is production-safe!"

wait_for_user

# ============ EXAMPLE 6 ============
explain "EXAMPLE 6: SIGKILL for stubborn processes" \
"If SIGTERM doesn't work, use SIGKILL (-9)."

show_and_try "Start an ignoring process:" \
"(trap '' TERM; sleep 100) & echo \"Process started (ignores SIGTERM)\""

wait_for_user

show_and_try "Try SIGTERM (won't work):" \
"PID=\$!; kill \$PID 2>/dev/null; sleep 1; echo 'Still running...'"

wait_for_user

show_and_try "Use SIGKILL to force stop:" \
"pkill -9 -f 'trap.*sleep' 2>/dev/null || true; echo 'Force killed' && sleep 1"

wait_for_user

explain "WHEN TO USE SIGKILL:" \
"✓ Use SIGTERM first (polite)
✓ Wait 5 seconds
✓ If still running, use SIGKILL

SIGKILL (-9) ALWAYS works!
But process can't cleanup.
Only use if SIGTERM fails."

wait_for_user

# ============ EXAMPLE 7 ============
explain "EXAMPLE 7: Find processes by name (pgrep)" \
"Instead of ps | grep, use pgrep (faster, easier)."

show_and_try "Start a test process:" \
"sleep 100 & echo \"Background job started\""

wait_for_user

show_and_try "Find all sleep processes:" \
"pgrep -l sleep"

wait_for_user

show_and_try "Count them:" \
"TOTAL=\$(pgrep -c sleep); echo \"Found \$TOTAL sleep processes\""

wait_for_user

explain "pgrep ADVANTAGES:" \
"ps aux | grep sleep     (shows grep too, need to filter)
pgrep sleep              (clean, just the PIDs)
pgrep -l sleep           (with names)
pgrep -c sleep           (count)
pgrep -u username        (by user)

Perfect for scripts!"

# Clean up
pkill -f 'sleep 100' 2>/dev/null || true
wait_for_user

# ============ EXAMPLE 8 ============
explain "EXAMPLE 8: Kill multiple processes by name (pkill)" \
"Use pkill to kill all processes matching a pattern."

show_and_try "Start three processes:" \
"sleep 100 & sleep 100 & sleep 100 & echo 'Three jobs started' && sleep 1"

wait_for_user

show_and_try "Verify they exist:" \
"pgrep -c sleep"

wait_for_user

show_and_try "Kill them all at once:" \
"pkill sleep && sleep 1 && echo 'All killed' && pgrep -c sleep || echo '(none running)'"

wait_for_user

explain "pkill vs kill:" \
"kill PID           Kill single process
pkill pattern      Kill all matching pattern

Example uses:
  pkill firefox      Kill all Firefox
  pkill -9 node      Force kill all Node.js
  pkill -u user app  Kill user's app processes

Be careful! Pattern matching can kill more than intended!"

wait_for_user

# ============ EXAMPLE 9 ============
explain "EXAMPLE 9: Process information and monitoring" \
"View detailed process information."

show_and_try "Start a test process:" \
"sleep 100 & sleep 100 & echo 'Processes started' && sleep 1"

wait_for_user

show_and_try "Show detailed process info:" \
"ps aux | head -4"

wait_for_user

explain "COLUMN MEANINGS:" \
"USER    = Who owns the process
PID     = Process ID (unique number)
%CPU    = CPU usage percentage
%MEM    = Memory usage percentage
VSZ     = Virtual memory size (KB)
RSS     = Physical memory (KB)
STAT    = State (S=sleep, R=running, Z=zombie)
TIME    = CPU time used
COMMAND = The actual command

This tells you everything about a process!"

# Clean up
pkill -f 'sleep 100' 2>/dev/null || true
wait_for_user

# ============ EXAMPLE 10 ============
explain "EXAMPLE 10: Monitor processes in real-time" \
"The 'top' command shows live process view."

show_and_try "Show one snapshot of top-like view:" \
"ps aux --sort=-%cpu | head -6"

wait_for_user

explain "REAL-TIME MONITORING:" \
"top command shows:
  - Sorted by CPU usage
  - Updates every few seconds
  - Live memory/swap info
  - System load average
  - Press 'q' to quit
  - Press 'k' to kill
  - Press 'M' to sort by memory

For production monitoring, use: htop (enhanced version)
Or: watch 'ps aux | sort -k3 -rn | head'"

wait_for_user

# ============ EXAMPLE 11 ============
explain "EXAMPLE 11: Track process with PID file" \
"Production apps save their PID to a file for management."

show_and_try "Create a PID file pattern:" \
"sleep 100 & echo \$! > /tmp/demo.pid && cat /tmp/demo.pid"

wait_for_user

show_and_try "Check if process is still running:" \
"PID=\$(cat /tmp/demo.pid); if ps -p \$PID > /dev/null; then echo 'Running'; else echo 'Stopped'; fi"

wait_for_user

show_and_try "Kill it and check again:" \
"PID=\$(cat /tmp/demo.pid); kill \$PID 2>/dev/null; sleep 1; if ps -p \$PID > /dev/null 2>&1; then echo 'Still running'; else echo 'Stopped'; fi"

wait_for_user

show_and_try "Cleanup PID file:" \
"rm /tmp/demo.pid && echo 'PID file cleaned up'"

wait_for_user

explain "PID FILE PATTERN:" \
"Most production apps do this:
  1. Start application
  2. Save PID to file: echo \$! > /tmp/app.pid
  3. Later, check: ps -p \$(cat /tmp/app.pid)
  4. If not running, restart it
  5. On stop, remove PID file

This is how supervisory systems work!"

wait_for_user

# ============ EXAMPLE 12 ============
explain "EXAMPLE 12: Real DevOps pattern - process restart script" \
"Combine everything into a production monitoring script."

show_and_try "Create a monitoring script:" \
"cat > /tmp/monitor.sh << 'SCRIPT'\n#!/bin/bash\nAPP='sleep 100'\nPIDFILE='/tmp/app.pid'\n\nif [ -f \$PIDFILE ]; then\n  PID=\$(cat \$PIDFILE)\n  if ps -p \$PID > /dev/null 2>&1; then\n    echo \"✓ Process running (PID: \$PID)\"\n  else\n    echo \"✗ Process dead! Restarting...\"\n    rm \$PIDFILE\n    \$APP &\n    echo \$! > \$PIDFILE\n    echo \"✓ Restarted\"\n  fi\nelse\n  echo \"Starting process...\"\n  \$APP &\n  echo \$! > \$PIDFILE\nfi\nSCRIPT\nchmod +x /tmp/monitor.sh\necho 'Monitoring script created'"

wait_for_user

show_and_try "View the script:" \
"head -20 /tmp/monitor.sh"

wait_for_user

show_and_try "Run it first time (starts process):" \
"/tmp/monitor.sh"

wait_for_user

show_and_try "Run it again (sees it's running):" \
"/tmp/monitor.sh"

wait_for_user

explain "THIS IS PRODUCTION AUTOMATION!" \
"The script:
  1. Checks if process is running
  2. If not, restarts it
  3. Tracks with PID file
  4. Run periodically (cron)
  5. Keeps app always up

This exact pattern runs production systems!"

# Clean up
pkill -f 'sleep 100' 2>/dev/null || true
rm -f /tmp/demo.pid /tmp/app.pid /tmp/monitor.sh 2>/dev/null
wait_for_user

# ============ PRACTICE TIME ============
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} YOUR TURN: TRY THESE CHALLENGES"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

echo "Challenge 1: Start 2 background jobs and list them"
echo "  - Start: sleep 50 &"
echo "  - Start: sleep 50 &"
echo "  - List: jobs"
echo ""
echo -e "${YELLOW}Type your commands:${NC}"
read -r chal1a
read -r chal1b
read -r chal1c
eval "$chal1a" 2>/dev/null
eval "$chal1b" 2>/dev/null
eval "$chal1c" 2>/dev/null

echo ""
echo ""
echo "Challenge 2: Find all sleep processes and count them"
echo "  Hint: pgrep -c sleep"
echo ""
echo -e "${YELLOW}Type your command:${NC}"
read -r chal2
eval "$chal2" 2>/dev/null

echo ""
echo ""
echo "Challenge 3: Kill all sleep processes"
echo "  Hint: pkill sleep"
echo ""
echo -e "${YELLOW}Type your command:${NC}"
read -r chal3
eval "$chal3" 2>/dev/null

# ============ SUMMARY ============
echo ""
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} SUMMARY: Processes, Signals, and Job Control"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

cat << 'EOF'
KEY COMMANDS:

JOB CONTROL (in shell):
  command &               Start in background
  jobs                    List background jobs
  fg %1                   Bring job to foreground
  bg %1                   Resume in background

SIGNALS (stopping processes):
  kill PID                Send SIGTERM (graceful)
  kill -9 PID             Send SIGKILL (force)
  pkill pattern           Kill by name
  pkill -9 pattern        Force kill by name

FIND PROCESSES:
  ps aux                  List all processes
  ps -p PID               Show specific process
  pgrep name              Find by name (returns PID)
  pgrep -l name           Find by name (with name)
  pgrep -c name           Count processes

MONITOR:
  top                     Live process view
  ps aux --sort=-%cpu     Sorted by CPU
  ps aux --sort=-%mem     Sorted by memory
  watch command           Run repeatedly

SIGNALS EXPLAINED:
  SIGTERM (15) = Terminate gracefully (default kill)
  SIGKILL (9)  = Force kill immediately
  SIGINT  (2)  = Interrupt (Ctrl+C)
  SIGSTOP (19) = Pause execution
  SIGCONT (18) = Resume execution

PROCESS STATES:
  R = Running
  S = Sleeping
  T = Stopped
  Z = Zombie
  D = Uninterruptible sleep

PRODUCTION PATTERNS:

1. Start process:
   app &
   echo $! > /tmp/app.pid

2. Check status:
   ps -p $(cat /tmp/app.pid)

3. Restart if down:
   if ! ps -p $(cat /tmp/app.pid) > /dev/null; then
     app &
     echo $! > /tmp/app.pid
   fi

4. Stop process:
   kill $(cat /tmp/app.pid)
   rm /tmp/app.pid

SIGNAL SEQUENCE (best practice):
  1. kill PID         (SIGTERM - graceful)
  2. wait 5 seconds
  3. kill -9 PID      (SIGKILL - force if needed)

REMEMBER:
  ✓ & runs in background
  ✓ SIGTERM first (graceful)
  ✓ SIGKILL only if needed (force)
  ✓ PID files track application
  ✓ pgrep/pkill > ps | grep
  ✓ Check before killing!
EOF

echo ""
echo -e "${YELLOW}Congratulations! You've mastered process management! 🎉${NC}"
echo ""
echo -e "${GREEN}Next: Build automated monitoring and restart scripts!${NC}"
echo ""
