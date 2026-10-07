#!/bin/zsh

# ═══════════════════════════════════════════════════════════════════════════════
# PRACTICE CHALLENGES - SOLUTIONS
# Run this script to see solutions to all challenges
# ═══════════════════════════════════════════════════════════════════════════════

show_challenge() {
    local num=$1
    
    case $num in
        1.1)
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║ PRACTICE CHALLENGE 1.1: SED -n - Extract lines from a file    ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            echo "OBJECTIVE:"
            echo "  Create a practice file with data, then extract specific lines using sed -n"
            echo ""
            echo "SETUP:"
            echo "  Create a file with 10 numbers (1-10)"
            echo ""
            echo "CHALLENGE TASKS:"
            echo ""
            echo "  1. Print only line 5"
            echo "     Expected: 5"
            echo ""
            echo "  2. Print lines 3-7"
            echo "     Expected: 3, 4, 5, 6, 7"
            echo ""
            echo "  3. Print every other line (odd numbers)"
            echo "     Expected: 1, 3, 5, 7, 9"
            echo ""
            echo "  4. Print the last 3 lines"
            echo "     Expected: 8, 9, 10"
            echo ""
            echo "SOLUTION:"
            echo "────────────"
            echo ""
            
            # Setup
            cat > /tmp/practice_numbers.txt << 'NUMBERS'
1
2
3
4
5
6
7
8
9
10
NUMBERS
            
            echo "Setup: Created file with numbers 1-10"
            echo ""
            
            echo "Task 1: Print line 5"
            echo "  Command: sed -n '5p' /tmp/practice_numbers.txt"
            echo "  Output:"
            sed -n '5p' /tmp/practice_numbers.txt
            echo ""
            
            echo "Task 2: Print lines 3-7"
            echo "  Command: sed -n '3,7p' /tmp/practice_numbers.txt"
            echo "  Output:"
            sed -n '3,7p' /tmp/practice_numbers.txt
            echo ""
            
            echo "Task 3: Print every other line (odd)"
            echo "  Command: sed -n '1~2p' /tmp/practice_numbers.txt"
            echo "  Output:"
            sed -n '1~2p' /tmp/practice_numbers.txt
            echo ""
            
            echo "Task 4: Print last 3 lines"
            echo "  Command: sed -n '8,\$p' /tmp/practice_numbers.txt"
            echo "  Output:"
            sed -n '8,$p' /tmp/practice_numbers.txt
            echo ""
            ;;
        
        1.2)
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║ PRACTICE CHALLENGE 1.2: SED -n - Filter by pattern           ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            echo "OBJECTIVE:"
            echo "  Use sed -n with pattern matching to extract lines"
            echo ""
            echo "SETUP:"
            echo "  Create a log file with different log levels"
            echo ""
            echo "CHALLENGE TASKS:"
            echo ""
            echo "  1. Print only ERROR lines"
            echo "  2. Print only WARNING lines"
            echo "  3. Print lines with numbers in them"
            echo ""
            echo "SOLUTION:"
            echo "────────────"
            echo ""
            
            # Setup
            cat > /tmp/practice_logs.txt << 'LOGS'
2024-10-07 12:00:00 INFO Starting service
2024-10-07 12:00:05 ERROR Failed to connect to database
2024-10-07 12:00:10 WARNING Memory usage at 75%
2024-10-07 12:00:15 INFO Processing request 001
2024-10-07 12:00:20 ERROR Connection timeout
2024-10-07 12:00:25 WARNING CPU usage at 85%
2024-10-07 12:00:30 INFO Request 002 completed
LOGS
            
            echo "Setup: Created log file with different levels"
            echo ""
            
            echo "Task 1: Print only ERROR lines"
            echo "  Command: sed -n '/ERROR/p' /tmp/practice_logs.txt"
            echo "  Output:"
            sed -n '/ERROR/p' /tmp/practice_logs.txt
            echo ""
            
            echo "Task 2: Print only WARNING lines"
            echo "  Command: sed -n '/WARNING/p' /tmp/practice_logs.txt"
            echo "  Output:"
            sed -n '/WARNING/p' /tmp/practice_logs.txt
            echo ""
            
            echo "Task 3: Print lines with numbers (like 001, 002)"
            echo "  Command: sed -n '/[0-9]\{3\}/p' /tmp/practice_logs.txt"
            echo "  Output:"
            sed -n '/[0-9]\{3\}/p' /tmp/practice_logs.txt
            echo ""
            ;;
        
        2.1)
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║ PRACTICE CHALLENGE 2.1: Command Substitution Basics          ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            echo "OBJECTIVE:"
            echo "  Use \$() to capture command output and store in variables"
            echo ""
            echo "CHALLENGE TASKS:"
            echo ""
            echo "  1. Store today's date in a variable"
            echo "  2. Store file count in a variable"
            echo "  3. Use the variables in messages"
            echo "  4. Use substitution in an if statement"
            echo ""
            echo "SOLUTION:"
            echo "────────────"
            echo ""
            
            echo "Task 1: Store today's date"
            echo "  Command: TODAY=\$(date +%Y-%m-%d)"
            TODAY=$(date +%Y-%m-%d)
            echo "  Result: TODAY=$TODAY"
            echo ""
            
            echo "Task 2: Store file count"
            echo "  Command: COUNT=\$(ls -1 /tmp/zshell_practice | wc -l)"
            COUNT=$(ls -1 /tmp/zshell_practice | wc -l)
            echo "  Result: COUNT=$COUNT"
            echo ""
            
            echo "Task 3: Use variables in messages"
            echo "  Command: echo \"Today is \$TODAY and there are \$COUNT files\""
            echo "  Result:"
            echo "Today is $TODAY and there are $COUNT files"
            echo ""
            
            echo "Task 4: Use in if statement"
            echo "  Command:"
            echo "    FILE_COUNT=\$(ls -1 /tmp/zshell_practice | wc -l)"
            echo "    if [[ \$FILE_COUNT -gt 3 ]]; then"
            echo "        echo \"More than 3 files found!\""
            echo "    fi"
            echo "  Result:"
            FILE_COUNT=$(ls -1 /tmp/zshell_practice | wc -l)
            if [[ $FILE_COUNT -gt 3 ]]; then
                echo "More than 3 files found!"
            fi
            echo ""
            ;;
        
        2.2)
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║ PRACTICE CHALLENGE 2.2: Command Substitution with Pipes      ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            echo "OBJECTIVE:"
            echo "  Combine pipes and command substitution for complex operations"
            echo ""
            echo "CHALLENGE TASKS:"
            echo ""
            echo "  1. Count ERROR lines in a log file"
            echo "  2. Extract first user from a file"
            echo "  3. Calculate total salary"
            echo "  4. Build a dynamic message"
            echo ""
            echo "SOLUTION:"
            echo "────────────"
            echo ""
            
            echo "Task 1: Count ERROR lines"
            echo "  Command: ERROR_COUNT=\$(grep -c ERROR /tmp/zshell_practice/system.log)"
            ERROR_COUNT=$(grep -c ERROR /tmp/zshell_practice/system.log)
            echo "  Result: ERROR_COUNT=$ERROR_COUNT"
            echo ""
            
            echo "Task 2: Extract first user name"
            echo "  Command: FIRST_USER=\$(cut -d: -f1 /tmp/zshell_practice/users.txt | head -1)"
            FIRST_USER=$(cut -d: -f1 /tmp/zshell_practice/users.txt | head -1)
            echo "  Result: FIRST_USER=$FIRST_USER"
            echo ""
            
            echo "Task 3: Calculate total salary"
            echo "  Command: TOTAL=\$(cut -d: -f4 /tmp/zshell_practice/users.txt | awk '{sum+=\$1} END {print sum}')"
            TOTAL=$(cut -d: -f4 /tmp/zshell_practice/users.txt | awk '{sum+=$1} END {print sum}')
            echo "  Result: TOTAL=$TOTAL"
            echo ""
            
            echo "Task 4: Build dynamic message"
            echo "  Command: echo \"User \$FIRST_USER has \$ERROR_COUNT errors out of \$TOTAL budget\""
            echo "  Result:"
            echo "User $FIRST_USER has $ERROR_COUNT errors out of $TOTAL budget"
            echo ""
            ;;
        
        3.1)
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║ PRACTICE CHALLENGE 3.1: Text Editing - Modify Data           ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            echo "OBJECTIVE:"
            echo "  Use sed, awk, cut to transform data from one format to another"
            echo ""
            echo "CHALLENGE TASKS:"
            echo ""
            echo "  1. Replace colons with commas in users.txt"
            echo "  2. Extract names and salaries"
            echo "  3. Find high earners (over \$70,000)"
            echo "  4. Calculate average salary"
            echo ""
            echo "SOLUTION:"
            echo "────────────"
            echo ""
            
            echo "Task 1: Replace colons with commas"
            echo "  Command: sed 's/:/,/g' /tmp/zshell_practice/users.txt"
            echo "  Output:"
            sed 's/:/,/g' /tmp/zshell_practice/users.txt
            echo ""
            
            echo "Task 2: Extract names and salaries only"
            echo "  Command: cut -d: -f1,4 /tmp/zshell_practice/users.txt"
            echo "  Output:"
            cut -d: -f1,4 /tmp/zshell_practice/users.txt
            echo ""
            
            echo "Task 3: Find high earners (over \$70,000)"
            echo "  Command: awk -F: '\$4 > 70000 {print \$1, \"earns \$\" \$4}' /tmp/zshell_practice/users.txt"
            echo "  Output:"
            awk -F: '$4 > 70000 {print $1, "earns $" $4}' /tmp/zshell_practice/users.txt
            echo ""
            
            echo "Task 4: Calculate average salary"
            echo "  Command: awk -F: '{sum+=\$4; count++} END {print \"Average: $\" int(sum/count)}' /tmp/zshell_practice/users.txt"
            echo "  Output:"
            awk -F: '{sum+=$4; count++} END {print "Average: $" int(sum/count)}' /tmp/zshell_practice/users.txt
            echo ""
            ;;
        
        3.2)
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║ PRACTICE CHALLENGE 3.2: Analyze Logs - Real DevOps Pattern   ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            echo "OBJECTIVE:"
            echo "  Combine multiple tools to analyze system logs"
            echo ""
            echo "CHALLENGE TASKS:"
            echo ""
            echo "  1. Count each log level (ERROR, WARNING, INFO)"
            echo "  2. Extract just the error messages"
            echo "  3. Find errors by type"
            echo "  4. Create a summary report"
            echo ""
            echo "SOLUTION:"
            echo "────────────"
            echo ""
            
            echo "Task 1: Count each log level"
            echo "  Commands:"
            echo "    ERROR_COUNT=\$(grep -c ERROR /tmp/zshell_practice/system.log)"
            echo "    WARNING_COUNT=\$(grep -c WARNING /tmp/zshell_practice/system.log)"
            echo "    INFO_COUNT=\$(grep -c INFO /tmp/zshell_practice/system.log)"
            ERROR_COUNT=$(grep -c ERROR /tmp/zshell_practice/system.log)
            WARNING_COUNT=$(grep -c WARNING /tmp/zshell_practice/system.log)
            INFO_COUNT=$(grep -c INFO /tmp/zshell_practice/system.log)
            echo "  Result:"
            echo "    ERROR: $ERROR_COUNT, WARNING: $WARNING_COUNT, INFO: $INFO_COUNT"
            echo ""
            
            echo "Task 2: Extract just error messages"
            echo "  Command: grep ERROR /tmp/zshell_practice/system.log | cut -d' ' -f4-"
            echo "  Output:"
            grep ERROR /tmp/zshell_practice/system.log | cut -d' ' -f4-
            echo ""
            
            echo "Task 3: Count errors by type (first word after ERROR)"
            echo "  Command: grep ERROR /tmp/zshell_practice/system.log | awk '{print \$4}' | sort | uniq -c"
            echo "  Output:"
            grep ERROR /tmp/zshell_practice/system.log | awk '{print $4}' | sort | uniq -c
            echo ""
            
            echo "Task 4: Create summary report"
            echo "  Result:"
            echo "════════════════════════════════════════════"
            echo "LOG ANALYSIS REPORT"
            echo "════════════════════════════════════════════"
            echo "Total Errors:   $ERROR_COUNT"
            echo "Total Warnings: $WARNING_COUNT"
            echo "Total Info:     $INFO_COUNT"
            echo "────────────────────────────────────────────"
            TOTAL=$((ERROR_COUNT + WARNING_COUNT + INFO_COUNT))
            echo "Total Lines:    $TOTAL"
            ERROR_PCT=$((ERROR_COUNT * 100 / TOTAL))
            echo "Error Rate:     ${ERROR_PCT}%"
            echo "════════════════════════════════════════════"
            echo ""
            ;;
        
        *)
            echo "Invalid challenge. Use: 1.1, 1.2, 2.1, 2.2, 3.1, 3.2"
            ;;
    esac
}

# Show menu if no arguments
if [[ -z "$1" ]]; then
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║            PRACTICE CHALLENGES - Solutions & Guidance          ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Usage: $0 <challenge>"
    echo ""
    echo "SED -n FLAG CHALLENGES:"
    echo "  1.1 - Extract lines from a file"
    echo "  1.2 - Filter by pattern"
    echo ""
    echo "COMMAND SUBSTITUTION CHALLENGES:"
    echo "  2.1 - Substitution basics"
    echo "  2.2 - Substitution with pipes"
    echo ""
    echo "TEXT EDITING CHALLENGES:"
    echo "  3.1 - Modify and transform data"
    echo "  3.2 - Analyze logs (real DevOps)"
    echo ""
    echo "Examples:"
    echo "  $0 1.1    # Show Challenge 1.1 with solution"
    echo "  $0 2.2    # Show Challenge 2.2 with solution"
    echo "  $0 3.2    # Show Challenge 3.2 with solution"
    echo ""
else
    show_challenge "$1"
fi
