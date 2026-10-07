#!/bin/zsh

# Interactive Command Substitution Tutorial
# A hands-on learning experience with guided prompts
# Usage: ./08-command-substitution-interactive.zsh

set -e

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to pause and wait for user
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

# Function to show command and result
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
    eval "$command"
}

# Main tutorial
clear

echo -e "${GREEN}"
cat << 'EOF'
╔════════════════════════════════════════════════════════╗
║                                                        ║
║   INTERACTIVE COMMAND SUBSTITUTION TUTORIAL           ║
║   Store command output in variables                   ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "${YELLOW}What is command substitution?${NC}"
echo "It lets you capture what a command prints and store it in a variable."
echo "This is ESSENTIAL for DevOps automation!"
echo ""
wait_for_user

# ============ EXAMPLE 1 ============
explain "EXAMPLE 1: Basic syntax - \$(command)" \
"Instead of running a command and reading output, you capture it.
Syntax: VARIABLE=\$(command)

Modern way: \$(command) 
Old way: \`command\` (backticks - avoid these!)

Let's see how it works:"

show_and_try "Step 1: Run a command normally (see output)" \
"echo 'Today is:' && date +%Y-%m-%d"

wait_for_user

show_and_try "Step 2: Capture the DATE in a variable" \
"TODAY=\$(date +%Y-%m-%d); echo 'Captured date: '\$TODAY"

wait_for_user

explain "WHAT HAPPENED:" \
"The \$(date +%Y-%m-%d) command ran INSIDE the variable assignment.
The output was stored in TODAY.
Then we used \$TODAY to print it later.

This is powerful because NOW you can USE the value!"

wait_for_user

# ============ EXAMPLE 2 ============
explain "EXAMPLE 2: Count files" \
"Let's capture how many files are in a directory."

show_and_try "Count files in examples/basic directory:" \
"FILE_COUNT=\$(ls -1 examples/basic | wc -l); echo 'Number of files: '\$FILE_COUNT"

wait_for_user

explain "WHAT JUST HAPPENED:" \
"We captured: ls -1 examples/basic | wc -l
This counts the files and stores the NUMBER in FILE_COUNT.

Now we can USE that number for decisions or calculations!"

wait_for_user

# ============ EXAMPLE 3 ============
explain "EXAMPLE 3: Get current user" \
"Let's capture who you are logged in as."

show_and_try "Get current username:" \
"CURRENT_USER=\$(whoami); echo 'You are logged in as: '\$CURRENT_USER"

wait_for_user

explain "COMMAND SUBSTITUTION POWERS:" \
"You can substitute:
  - Date/time commands
  - File counts and searches
  - User information
  - System status (CPU, memory, etc)
  - Math calculations
  - Database queries
  - API calls
  - ANYTHING that prints output!"

wait_for_user

# ============ EXAMPLE 4 ============
explain "EXAMPLE 4: Use in IF statements" \
"Command substitution is PERFECT for making decisions.
Check a value and do different things based on the result."

show_and_try "Check if file exists, store result:" \
"FILE_EXISTS=\$([ -f /tmp/zshell_practice/users.txt ] && echo 'YES' || echo 'NO'); echo 'Test file exists? '\$FILE_EXISTS"

wait_for_user

explain "DECISION MAKING:" \
"We used: [ -f FILE ] && echo 'YES' || echo 'NO'
This checks if file exists:
  If YES: prints 'YES'
  If NO: prints 'NO'

Then we stored that in FILE_EXISTS!
Now our script can make decisions!"

wait_for_user

# ============ EXAMPLE 5 ============
explain "EXAMPLE 5: Calculate age from year" \
"Command substitution works with math and calculations.
Let's calculate how many years since a specific year."

show_and_try "Calculate years since 2020:" \
"CURRENT_YEAR=\$(date +%Y); YEARS_SINCE=\$((CURRENT_YEAR - 2020)); echo 'Years since 2020: '\$YEARS_SINCE"

wait_for_user

explain "MATH WITH SUBSTITUTION:" \
"We first captured: CURRENT_YEAR=\$(date +%Y)
Then used it: YEARS_SINCE=\$((CURRENT_YEAR - 2020))

The \$((math)) syntax does arithmetic.
Now YEARS_SINCE contains the number!"

wait_for_user

# ============ EXAMPLE 6 ============
explain "EXAMPLE 6: Practical use - check file size" \
"DevOps often needs to check file sizes and make decisions."

show_and_try "Get size of a log file:" \
"LOG_FILE='/tmp/zshell_practice/system.log'; FILE_SIZE=\$(wc -c < \$LOG_FILE); echo 'Log file size: '\$FILE_SIZE' bytes'"

wait_for_user

explain "REAL WORLD USE:" \
"This is how you build monitoring scripts!
Check file size → trigger alerts
Check process status → restart if down
Count errors in logs → send email
All using command substitution!"

wait_for_user

# ============ EXAMPLE 7 ============
explain "EXAMPLE 7: Multi-line substitution (professional format)" \
"For complex commands, spread them across lines.
This is how REAL scripts look!"

show_and_try "Professional multi-line format:" \
"ERROR_COUNT=\$(
  grep -c 'ERROR' /tmp/zshell_practice/system.log 2>/dev/null || echo 0
); echo 'Errors found: '\$ERROR_COUNT"

wait_for_user

explain "PROFESSIONAL FORMATTING:" \
"Notice how the command spans multiple lines?
  \$( on the first line
     command continues on next line
  ) closes it on the last line

This makes complex commands readable!
Real DevOps scripts look like this."

wait_for_user

# ============ EXAMPLE 8 ============
explain "EXAMPLE 8: Nesting substitutions" \
"Advanced: use substitution INSIDE substitution.
This enables powerful automation!"

show_and_try "Find and count matching files:" \
"MATCH_COUNT=\$(find /tmp/zshell_practice -name '*.txt' 2>/dev/null | wc -l); echo 'Found '\$MATCH_COUNT' text files'"

wait_for_user

explain "COMMAND PIPING + SUBSTITUTION:" \
"We used: find | wc -l
The entire pipe output (a number) was captured.
This is how you build complex automation!"

wait_for_user

# ============ EXAMPLE 9 ============
explain "EXAMPLE 9: Store output with newlines" \
"Substitution preserves line breaks in output.
This lets you work with multi-line data!"

show_and_try "Store all lines from a file:" \
"USERS=\$(cat /tmp/zshell_practice/users.txt | head -2); echo 'First 2 users:'; echo \"\$USERS\""

wait_for_user

explain "PRESERVING FORMAT:" \
"When you do VARIABLE=\"\$(command)\" with quotes,
it preserves newlines and formatting.
Without quotes, it squashes them to one line.

Always use quotes around \$VARIABLE for safety!"

wait_for_user

# ============ EXAMPLE 10 ============
explain "EXAMPLE 10: Combining substitutions" \
"Use multiple substitutions together for power!"

show_and_try "Get username, date, and file count:" \
"USER=\$(whoami); DATE=\$(date +%Y-%m-%d); FILES=\$(ls -1 examples/basic | wc -l); echo \"User: \$USER, Date: \$DATE, Files: \$FILES\""

wait_for_user

explain "COMBINING POWER:" \
"Each \$(command) runs independently and stores its result.
Now you have multiple values to work with.
This is the foundation of automation!"

wait_for_user

# ============ EXAMPLE 11 ============
explain "EXAMPLE 11: Error handling with substitution" \
"What if a command fails? Handle it gracefully!"

show_and_try "Substitute with fallback value:" \
"RESULT=\$(grep 'NOTFOUND' /tmp/zshell_practice/system.log 2>/dev/null || echo 'No matches'); echo 'Search result: '\$RESULT"

wait_for_user

explain "ERROR HANDLING:" \
"We used: command || echo 'fallback'
If the command fails, use the fallback value.
This prevents scripts from breaking!"

wait_for_user

# ============ EXAMPLE 12 ============
explain "EXAMPLE 12: Real DevOps pattern - system monitor" \
"Let's build a mini monitoring script using everything!"

show_and_try "Monitor system status:" \
"echo '=== System Monitor ===' && \
HOST=\$(hostname) && \
UPTIME=\$(uptime -p 2>/dev/null || echo 'unknown') && \
USER_COUNT=\$(wc -l < /tmp/zshell_practice/users.txt 2>/dev/null || echo 0) && \
echo \"Host: \$HOST\" && \
echo \"Uptime: \$UPTIME\" && \
echo \"Users configured: \$USER_COUNT\""

wait_for_user

explain "REAL MONITORING SCRIPT:" \
"This is how DevOps scripts work:
  1. Capture system values with \$()
  2. Store in variables
  3. Use for decisions or reporting
  4. Handle errors with fallbacks
  5. Combine multiple sources

This pattern scales to full automation!"

wait_for_user

# ============ PRACTICE TIME ============
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} YOUR TURN: TRY THESE CHALLENGES"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

echo "Challenge 1: Capture the current hour and print it"
echo "Hint: Use \$(date +%H)"
echo ""
echo -e "${YELLOW}Type your command:${NC}"
read -r challenge1
echo -e "${CYAN}Output:${NC}"
eval "$challenge1" 2>/dev/null || echo "Try: HOUR=\$(date +%H); echo \$HOUR"

echo ""
echo ""
echo "Challenge 2: Count how many lines in users.txt and say how many"
echo "Hint: Use \$(wc -l < file)"
echo ""
echo -e "${YELLOW}Type your command:${NC}"
read -r challenge2
echo -e "${CYAN}Output:${NC}"
eval "$challenge2" 2>/dev/null || echo "Try: LINES=\$(wc -l < /tmp/zshell_practice/users.txt); echo \$LINES' users'"

echo ""
echo ""
echo "Challenge 3: Create a backup filename with today's date"
echo "Hint: Create a variable like backup_\$(date +%Y-%m-%d).txt"
echo ""
echo -e "${YELLOW}Type your command:${NC}"
read -r challenge3
echo -e "${CYAN}Output:${NC}"
eval "$challenge3" 2>/dev/null || echo "Try: BACKUP=\"backup_\$(date +%Y-%m-%d).txt\"; echo \$BACKUP"

# ============ SUMMARY ============
echo ""
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} SUMMARY: Command Substitution Patterns"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
cat << 'EOF'
Basic Patterns:

  VARIABLE=$(command)              Capture output
  VARIABLE=$(command | filter)     Pipe commands
  echo $VARIABLE                   Use the value
  echo "Count: $VARIABLE"           Use in text

Decision Making:

  RESULT=$([ -f file ] && echo YES || echo NO)    Check condition
  if [ "$COUNT" -gt 100 ]; then                    Use for decisions

Multi-line Format:

  VALUE=$(
    command with many arguments \
    | pipe to another command
  )

Real DevOps Patterns:

  STATUS=$(systemctl is-active nginx)    Check service
  SIZE=$(du -sh /var/log)                Check disk usage
  ERRORS=$(grep -c ERROR /var/log/*.log) Count errors
  BACKUP_FILE="backup_$(date +%Y%m%d).tar" Create timestamps

REMEMBER:
  $() = Modern, nestable, preferred
  `command` = Old, don't nest, avoid
  Without -n → captures newlines (use quotes!)
  Without quotes → squashes to single line
  Always quote: echo "$VARIABLE" (safe!)
  Combine multiple $(commands) for power!

POWER:
  Command substitution is the foundation of automation
  Store → Check → Decide → Act
  This is how systems monitor themselves!
EOF

echo ""
echo -e "${YELLOW}Congratulations! You've mastered command substitution! 🎉${NC}"
echo ""
echo -e "${GREEN}Next: Practice using these in real scripts and conditions!${NC}"
echo ""
