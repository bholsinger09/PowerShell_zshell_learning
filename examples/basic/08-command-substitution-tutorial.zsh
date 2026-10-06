#!/bin/zsh

# ═══════════════════════════════════════════════════════════════════════════════
# COMMAND SUBSTITUTION TUTORIAL
# Learn to use $() to capture command output and store in variables
# ═══════════════════════════════════════════════════════════════════════════════

demo() {
    local num=$1
    
    case $num in
        1)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 1: SIMPLE COMMAND SUBSTITUTION"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "What is command substitution?"
            echo "It captures the OUTPUT of a command and stores it in a variable."
            echo ""
            echo "Without substitution:"
            echo "  echo 'Hello'"
            echo ""
            echo "With substitution:"
            echo "  GREETING=\$(echo 'Hello')"
            echo "  echo \$GREETING"
            echo ""
            echo "Both show the same output, but the second STORES it!"
            echo ""
            GREETING=$(echo 'Hello')
            echo "Result: $GREETING"
            echo ""
            ;;
        
        2)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 2: GET TODAY'S DATE"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: TODAY=\$(date +%Y-%m-%d)"
            echo ""
            TODAY=$(date +%Y-%m-%d)
            echo "Stored in variable TODAY: $TODAY"
            echo ""
            echo "Now use it:"
            echo "  echo \"Today's date is: \$TODAY\""
            echo ""
            echo "Result:"
            echo "Today's date is: $TODAY"
            echo ""
            ;;
        
        3)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 3: COUNT LINES IN A FILE"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: LINE_COUNT=\$(wc -l < /tmp/zshell_practice/users.txt)"
            echo ""
            LINE_COUNT=$(wc -l < /tmp/zshell_practice/users.txt)
            echo "Stored in variable LINE_COUNT: $LINE_COUNT"
            echo ""
            echo "Use it in a message:"
            echo "  echo \"The file has \$LINE_COUNT lines\""
            echo ""
            echo "Result:"
            echo "The file has $LINE_COUNT lines"
            echo ""
            ;;
        
        4)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 4: EXTRACT FIRST LINE"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: FIRST_USER=\$(head -1 /tmp/zshell_practice/users.txt)"
            echo ""
            FIRST_USER=$(head -1 /tmp/zshell_practice/users.txt)
            echo "Stored in variable FIRST_USER: $FIRST_USER"
            echo ""
            echo "Result:"
            echo "$FIRST_USER"
            echo ""
            ;;
        
        5)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 5: USE WITH IF STATEMENT"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command:"
            echo "  FILE_COUNT=\$(ls -1 /tmp/zshell_practice | wc -l)"
            echo "  if [[ \$FILE_COUNT -gt 3 ]]; then"
            echo "      echo \"More than 3 files!\""
            echo "  fi"
            echo ""
            FILE_COUNT=$(ls -1 /tmp/zshell_practice | wc -l)
            if [[ $FILE_COUNT -gt 3 ]]; then
                echo "Result: More than 3 files!"
                echo "Actual count: $FILE_COUNT files"
            fi
            echo ""
            ;;
        
        6)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 6: COMBINE WITH PIPES"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: ERROR_COUNT=\$(grep -c ERROR /tmp/zshell_practice/system.log)"
            echo ""
            ERROR_COUNT=$(grep -c ERROR /tmp/zshell_practice/system.log)
            echo "Stored in variable ERROR_COUNT: $ERROR_COUNT"
            echo ""
            echo "Use it:"
            echo "  echo \"Found \$ERROR_COUNT errors in the log\""
            echo ""
            echo "Result:"
            echo "Found $ERROR_COUNT errors in the log"
            echo ""
            ;;
        
        7)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 7: EXTRACT SPECIFIC FIELDS"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: NAMES=\$(cut -d: -f1 /tmp/zshell_practice/users.txt)"
            echo ""
            NAMES=$(cut -d: -f1 /tmp/zshell_practice/users.txt)
            echo "Stored in variable NAMES:"
            echo ""
            echo "$NAMES"
            echo ""
            ;;
        
        8)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 8: CALCULATE WITH AWK"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command:"
            echo "  TOTAL_SALARY=\$(cut -d: -f4 /tmp/zshell_practice/users.txt | awk '{sum+=\$1} END {print sum}')"
            echo ""
            TOTAL_SALARY=$(cut -d: -f4 /tmp/zshell_practice/users.txt | awk '{sum+=$1} END {print sum}')
            echo "Stored in variable TOTAL_SALARY: $TOTAL_SALARY"
            echo ""
            echo "Result:"
            echo "Total salary of all employees: \$$TOTAL_SALARY"
            echo ""
            ;;
        
        9)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 9: MULTI-LINE SUBSTITUTION (PROFESSIONAL)"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "For complex commands, use multiple lines for clarity:"
            echo ""
            echo "Command:"
            echo "  ERROR_DETAILS=\$(grep ERROR /tmp/zshell_practice/system.log | cut -d' ' -f1-3,5-)"
            echo "  echo \"\$ERROR_DETAILS\""
            echo ""
            echo "Result:"
            ERROR_DETAILS=$(grep ERROR /tmp/zshell_practice/system.log | cut -d' ' -f1-3,5-)
            echo "$ERROR_DETAILS"
            echo ""
            ;;
        
        10)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 10: USE IN ECHO WITH TEXT"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "You can embed command substitution directly in strings:"
            echo ""
            echo "Command:"
            echo "  echo \"I have \$(ls -1 /tmp/zshell_practice | wc -l) test files\""
            echo ""
            echo "Result:"
            echo "I have $(ls -1 /tmp/zshell_practice | wc -l) test files"
            echo ""
            ;;
        
        11)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 11: NESTING (ADVANCED)"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "You can put one substitution inside another:"
            echo ""
            echo "Command:"
            echo "  FIRST_NAME=\$(head -1 /tmp/zshell_practice/users.txt | cut -d: -f1)"
            echo ""
            FIRST_NAME=$(head -1 /tmp/zshell_practice/users.txt | cut -d: -f1)
            echo "Stored in variable FIRST_NAME: $FIRST_NAME"
            echo ""
            echo "This combines:"
            echo "  1. head -1 = get first line"
            echo "  2. cut -d: -f1 = extract field 1 from that line"
            echo ""
            echo "Result: First user is: $FIRST_NAME"
            echo ""
            ;;
        
        12)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 12: REAL DEVOPS USE CASE"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Check if errors are above threshold and send alert:"
            echo ""
            echo "Command:"
            echo "  ERROR_COUNT=\$(grep -c ERROR /tmp/zshell_practice/system.log)"
            echo "  if [[ \$ERROR_COUNT -gt 2 ]]; then"
            echo "      echo \"⚠️  ALERT: Found \$ERROR_COUNT errors - check logs!\""
            echo "  fi"
            echo ""
            ERROR_COUNT=$(grep -c ERROR /tmp/zshell_practice/system.log)
            if [[ $ERROR_COUNT -gt 2 ]]; then
                echo "Result:"
                echo "⚠️  ALERT: Found $ERROR_COUNT errors - check logs!"
            fi
            echo ""
            ;;
        
        all)
            for i in {1..12}; do
                demo $i
            done
            ;;
        
        *)
            echo "Invalid example number. Use 1-12 or 'all'"
            ;;
    esac
}

# Show help if no arguments
if [[ -z "$1" ]]; then
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║     COMMAND SUBSTITUTION TUTORIAL - Learn by Examples          ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Usage: $0 <example_number>"
    echo ""
    echo "Examples:"
    echo "  1  - Simple command substitution"
    echo "  2  - Get today's date"
    echo "  3  - Count lines in a file"
    echo "  4  - Extract first line"
    echo "  5  - Use with if statement"
    echo "  6  - Combine with pipes"
    echo "  7  - Extract specific fields"
    echo "  8  - Calculate with awk"
    echo "  9  - Multi-line substitution (professional)"
    echo "  10 - Use in echo with text"
    echo "  11 - Nesting (advanced)"
    echo "  12 - Real DevOps use case"
    echo ""
    echo "  all - Show all 12 examples"
    echo ""
    echo "Examples:"
    echo "  $0 1    # Show example 1"
    echo "  $0 5    # Show example 5"
    echo "  $0 all  # Show all 12 examples"
    echo ""
else
    demo "$1"
fi
