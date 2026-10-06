#!/bin/zsh

# ============================================================
# TEXT EDITING & COMMAND LINE CONTINUATION - LEARNING SCRIPT
# ============================================================
# Level 4: Advanced DevOps Automation
# 
# Learn how to:
# 1. Edit text files from command line (sed, awk)
# 2. Continue long commands across multiple lines
# 3. Format multi-line scripts for readability
# 4. Combine text editing with pipes
# 
# Run: ./06-text-editing-and-line-continuation.zsh [1-20|demo|all]
# ============================================================

# ============ EXAMPLE 1: Basic sed Substitution ============
example_sed_basic() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 1: SED - Basic find and replace"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original text:"
    echo "Hello World"
    echo "Hello Zshell"
    echo "Hello DevOps"
    
    echo ""
    echo "Replace 'Hello' with 'Goodbye':"
    echo -e "Hello World\nHello Zshell\nHello DevOps" | sed 's/Hello/Goodbye/'
    
    echo ""
    echo "Explanation:"
    echo "  sed 's/find/replace/'  → Replace first occurrence on each line"
    echo "  sed 's/find/replace/g' → Replace ALL occurrences (global)"
    echo "  sed 's/find/replace/2' → Replace only 2nd occurrence"
}

# ============ EXAMPLE 2: sed - Replace All Occurrences ============
example_sed_global() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 2: SED - Global replacement (all on each line)"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original:"
    echo "cat cat cat and dog dog dog"
    
    echo ""
    echo "Replace all 'cat' with 'dog':"
    echo "cat cat cat and dog dog dog" | sed 's/cat/dog/g'
    
    echo ""
    echo "Explanation:"
    echo "  Without g: Only first 'cat' replaced"
    echo "  With g:    All 'cat' replaced"
}

# ============ EXAMPLE 3: sed - Delete Lines ============
example_sed_delete() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 3: SED - Delete matching lines"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original text:"
    echo -e "Line 1\nLine 2 - DELETE\nLine 3\nLine 4 - DELETE\nLine 5"
    
    echo ""
    echo "Delete lines containing 'DELETE':"
    echo -e "Line 1\nLine 2 - DELETE\nLine 3\nLine 4 - DELETE\nLine 5" | sed '/DELETE/d'
    
    echo ""
    echo "Explanation:"
    echo "  sed '/pattern/d' → Delete lines matching pattern"
    echo "  d               → Delete command"
}

# ============ EXAMPLE 4: sed - Print Specific Lines ============
example_sed_print() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 4: SED - Print specific lines only"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original (10 lines):"
    seq 1 10
    
    echo ""
    echo "Print only lines 3-7:"
    seq 1 10 | sed -n '3,7p'
    
    echo ""
    echo "Explanation:"
    echo "  sed -n      → Suppress default output"
    echo "  '3,7p'      → Print lines 3 to 7"
    echo "  '5p'        → Print only line 5"
    echo "  '1p;5p;10p' → Print lines 1, 5, and 10"
}

# ============ EXAMPLE 5: awk - Extract Columns ============
example_awk_columns() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 5: AWK - Extract specific columns"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original data (space-separated):"
    echo "John 30 Engineer 50000"
    echo "Sarah 28 Manager 60000"
    echo "Mike 35 Director 80000"
    
    echo ""
    echo "Extract column 1 (name) and column 3 (role):"
    echo -e "John 30 Engineer 50000\nSarah 28 Manager 60000\nMike 35 Director 80000" \
        | awk '{print $1, $3}'
    
    echo ""
    echo "Explanation:"
    echo "  awk '{print $1}' → Print column 1"
    echo "  awk '{print $1, $3}' → Print columns 1 and 3"
    echo "  awk '{print $NF}' → Print last column (NF = Number of Fields)"
}

# ============ EXAMPLE 6: awk - With Field Separator ============
example_awk_separator() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 6: AWK - Use different field separator"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original data (colon-separated):"
    echo "john:engineer:50000"
    echo "sarah:manager:60000"
    echo "mike:director:80000"
    
    echo ""
    echo "Extract name and salary:"
    echo -e "john:engineer:50000\nsarah:manager:60000\nmike:director:80000" \
        | awk -F: '{print $1, $3}'
    
    echo ""
    echo "Explanation:"
    echo "  -F: → Use colon as field separator (default is space)"
    echo "  -F, → Use comma as field separator"
    echo "  -F'|' → Use pipe as field separator"
}

# ============ EXAMPLE 7: awk - Conditional Processing ============
example_awk_condition() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 7: AWK - Filter by condition"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original data:"
    echo "John 30 50000"
    echo "Sarah 28 60000"
    echo "Mike 35 80000"
    echo "Lisa 25 45000"
    
    echo ""
    echo "Show only people over 30:"
    echo -e "John 30 50000\nSarah 28 60000\nMike 35 80000\nLisa 25 45000" \
        | awk '$2 > 30 {print $1, $2, $3}'
    
    echo ""
    echo "Explanation:"
    echo "  awk 'condition {action}' → If condition true, do action"
    echo "  $2 > 30 → Column 2 greater than 30"
    echo "  $3 > 55000 → Column 3 greater than 55000"
}

# ============ EXAMPLE 8: awk - Calculate Sum ============
example_awk_sum() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 8: AWK - Calculate totals and averages"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original data (sales):"
    echo "100"
    echo "250"
    echo "150"
    echo "300"
    
    echo ""
    echo "Calculate sum:"
    echo -e "100\n250\n150\n300" | awk '{sum += $1} END {print "Total:", sum}'
    
    echo ""
    echo "Calculate average:"
    echo -e "100\n250\n150\n300" | awk '{sum += $1; count++} END {print "Average:", sum/count}'
    
    echo ""
    echo "Explanation:"
    echo "  sum += $1    → Add column 1 to sum"
    echo "  count++      → Increment counter"
    echo "  END {action} → Do action after all lines processed"
}

# ============ EXAMPLE 9: Line Continuation - Backslash ============
example_continuation_backslash() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 9: LINE CONTINUATION - Using backslash ()"
    echo "════════════════════════════════════════════════════════"
    
    echo "Long command split across multiple lines:"
    echo ""
    echo "Command:"
    echo '  ls -lah \'
    echo '    | grep ".zsh" \'
    echo '    | head -5'
    
    echo ""
    echo "Output:"
    ls -lah \
        | grep ".zsh" \
        | head -5
    
    echo ""
    echo "Explanation:"
    echo "  Backslash () at end of line → Continue on next line"
    echo "  Must be LAST character (no space after it)"
    echo "  Pipes can start next line"
}

# ============ EXAMPLE 10: Line Continuation - Pipes ============
example_continuation_pipes() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 10: LINE CONTINUATION - Pipe at start of line"
    echo "════════════════════════════════════════════════════════"
    
    echo "Long pipe chain, easier to read:"
    echo ""
    echo "Command:"
    echo '  cat /etc/passwd'
    echo '  | head -5'
    echo '  | cut -d: -f1'
    
    echo ""
    echo "Output:"
    # Show users (head -5)
    cat /etc/passwd \
    | head -5 \
    | cut -d: -f1
    
    echo ""
    echo "Explanation:"
    echo "  Pipe at beginning of line shows continuation"
    echo "  More readable than backslash method"
    echo "  Same result, clearer intent"
}

# ============ EXAMPLE 11: Multi-line If Statement ============
example_multiline_if() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 11: MULTI-LINE IF STATEMENT"
    echo "════════════════════════════════════════════════════════"
    
    FILE_COUNT=$(ls examples/basic/*.zsh 2>/dev/null | wc -l)
    
    if [[ $FILE_COUNT -gt 2 ]]; then
        echo "✅ Found $FILE_COUNT scripts"
        echo "This is a multi-line if statement:"
        echo "  - Readable and clear"
        echo "  - Each action on separate line"
        echo "  - Still executes as one command"
    fi
    
    echo ""
    echo "Format:"
    echo "  if [[ condition ]]; then"
    echo "      action1"
    echo "      action2"
    echo "      action3"
    echo "  fi"
}

# ============ EXAMPLE 12: Multi-line Command Substitution ============
example_multiline_substitution() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 12: MULTI-LINE COMMAND SUBSTITUTION"
    echo "════════════════════════════════════════════════════════"
    
    RESULT=$(
        ls -1 examples/basic/*.zsh 2>/dev/null \
        | wc -l
    )
    
    echo "✅ Command substitution result: $RESULT"
    
    echo ""
    echo "Format:"
    echo '  RESULT=$('
    echo "      command1"
    echo "      | command2"
    echo "      | command3"
    echo '  )'
}

# ============ EXAMPLE 13: sed - Edit File In-Place ============
example_sed_inplace() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 13: SED - Edit file in-place"
    echo "════════════════════════════════════════════════════════"
    
    # Create temp file
    TEMP_FILE="/tmp/test_edit.txt"
    cat > "$TEMP_FILE" << 'EOF'
server1 production
server2 staging
server3 development
EOF
    
    echo "Original file:"
    cat "$TEMP_FILE"
    
    echo ""
    echo "After sed replacement (in-place):"
    sed -i '' 's/production/PROD/' "$TEMP_FILE"
    cat "$TEMP_FILE"
    
    echo ""
    echo "Explanation:"
    echo "  sed -i 's/find/replace/' file → Edit file in-place"
    echo "  sed -i.bak 's/find/replace/' file → Backup original as file.bak"
    echo "  ⚠️  CAREFUL: Changes are permanent!"
    
    # Cleanup
    rm -f "$TEMP_FILE" "$TEMP_FILE.bak"
}

# ============ EXAMPLE 14: tr - Character Translation ============
example_tr_basic() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 14: TR - Translate characters"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original text:"
    echo "hello world"
    
    echo ""
    echo "Uppercase:"
    echo "hello world" | tr a-z A-Z
    
    echo ""
    echo "Lowercase:"
    echo "HELLO WORLD" | tr A-Z a-z
    
    echo ""
    echo "Remove vowels:"
    echo "hello world" | tr -d aeiouAEIOU
    
    echo ""
    echo "Explanation:"
    echo "  tr 'from' 'to'    → Translate characters"
    echo "  tr a-z A-Z        → Lowercase to uppercase"
    echo "  tr -d 'pattern'   → Delete matching characters"
}

# ============ EXAMPLE 15: Combine sed + awk in Pipeline ============
example_combined_sed_awk() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 15: COMBINE SED + AWK IN PIPELINE"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original log data:"
    echo "ERROR: Connection timeout at server1"
    echo "INFO: Process started at server2"
    echo "ERROR: Memory leak at server3"
    echo "WARNING: High CPU at server1"
    
    echo ""
    echo "Extract ERROR lines and server name:"
    echo -e "ERROR: Connection timeout at server1\nINFO: Process started at server2\nERROR: Memory leak at server3\nWARNING: High CPU at server1" \
        | grep ERROR \
        | sed 's/ERROR: //' \
        | awk -F' at ' '{print "Fix on: " $2}'
    
    echo ""
    echo "Explanation:"
    echo "  grep ERROR           → Filter error lines"
    echo "  sed 's/ERROR: //'    → Remove ERROR prefix"
    echo "  awk -F' at '         → Split by ' at '"
    echo "  awk '{print $2}'     → Extract server name"
}

# ============ EXAMPLE 16: String Processing with cut ============
example_cut_command() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 16: CUT - Extract fields by position or delimiter"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original data:"
    echo "john:30:engineer:50000"
    echo "sarah:28:manager:60000"
    echo "mike:35:director:80000"
    
    echo ""
    echo "Extract name and salary (fields 1 and 4):"
    echo -e "john:30:engineer:50000\nsarah:28:manager:60000\nmike:35:director:80000" \
        | cut -d: -f1,4
    
    echo ""
    echo "Explanation:"
    echo "  cut -d: -f1,4  → Use : as delimiter, extract fields 1 and 4"
    echo "  cut -d: -f2-   → Extract from field 2 to end"
    echo "  cut -c1-5      → Extract characters 1 through 5"
}

# ============ EXAMPLE 17: grep with Regular Expressions ============
example_grep_regex() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 17: GREP - Regular expressions"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original data:"
    echo "user1 - logged in at 10:00"
    echo "user2 - logged in at 11:30"
    echo "user3 - logged out at 14:45"
    echo "user4 - logged in at 15:20"
    
    echo ""
    echo "Find all 'logged in' entries:"
    echo -e "user1 - logged in at 10:00\nuser2 - logged in at 11:30\nuser3 - logged out at 14:45\nuser4 - logged in at 15:20" \
        | grep "logged in"
    
    echo ""
    echo "Find patterns with regex:"
    echo -e "Error Code: 404\nError Code: 500\nSuccess Code: 200" \
        | grep -E "Error|500"
    
    echo ""
    echo "Explanation:"
    echo "  grep 'text'       → Literal text match"
    echo "  grep -E 'regex'   → Use extended regex"
    echo "  grep -i 'text'    → Case insensitive"
    echo "  grep -v 'text'    → Inverse (NOT matching)"
}

# ============ EXAMPLE 18: Practical - Log File Analysis ============
example_practical_logs() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 18: PRACTICAL - Analyze log file"
    echo "════════════════════════════════════════════════════════"
    
    # Create sample log
    LOG_FILE="/tmp/app.log"
    cat > "$LOG_FILE" << 'EOF'
2024-01-10 10:00:00 INFO Starting application
2024-01-10 10:01:15 ERROR Connection failed
2024-01-10 10:02:30 WARNING Memory usage high
2024-01-10 10:03:45 ERROR Connection failed
2024-01-10 10:04:50 INFO Service online
2024-01-10 10:05:00 ERROR Connection failed
EOF
    
    echo "Log file content:"
    head -3 "$LOG_FILE"
    echo "..."
    
    echo ""
    echo "Count errors per type:"
    grep ERROR "$LOG_FILE" | wc -l | xargs echo "ERROR count:"
    
    echo ""
    echo "Find all connection failures:"
    grep "Connection failed" "$LOG_FILE" | wc -l | xargs echo "Connection failures:"
    
    echo ""
    echo "Extract just the timestamps:"
    cat "$LOG_FILE" | awk '{print $1, $2}' | head -3
    echo "..."
    
    # Cleanup
    rm -f "$LOG_FILE"
}

# ============ EXAMPLE 19: Practical - Config File Editing ============
example_practical_config() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 19: PRACTICAL - Edit config files"
    echo "════════════════════════════════════════════════════════"
    
    # Create sample config
    CONFIG="/tmp/app.conf"
    cat > "$CONFIG" << 'EOF'
# Application Configuration
DEBUG=false
ENVIRONMENT=development
MAX_CONNECTIONS=100
TIMEOUT=30
LOG_LEVEL=info
EOF
    
    echo "Original config:"
    grep -v "^#" "$CONFIG" | grep -v "^$"
    
    echo ""
    echo "Change ENVIRONMENT to production:"
    sed -i 's/ENVIRONMENT=development/ENVIRONMENT=production/' "$CONFIG"
    grep ENVIRONMENT "$CONFIG"
    
    echo ""
    echo "Disable DEBUG mode:"
    sed -i 's/DEBUG=false/DEBUG=true/' "$CONFIG"
    grep DEBUG "$CONFIG"
    
    echo ""
    echo "Extract all variables:"
    cat "$CONFIG" | grep "=" | grep -v "^#"
    
    # Cleanup
    rm -f "$CONFIG"
}

# ============ EXAMPLE 20: Real-World DevOps Script ============
example_real_world_devops() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 20: REAL DEVOPS - Process management status"
    echo "════════════════════════════════════════════════════════"
    
    echo "Sample: Find and count running processes"
    echo ""
    
    PROC_COUNT=$(ps aux | wc -l)
    echo "✅ Total processes running: $PROC_COUNT"
    
    echo ""
    echo "Show process count by user:"
    ps aux \
        | tail -n +2 \
        | awk '{print $1}' \
        | sort \
        | uniq -c \
        | sort -rn \
        | head -3
    
    echo ""
    echo "This demonstrates:"
    echo "  • ps aux → Get all processes"
    echo "  • tail -n +2 → Skip header"
    echo "  • awk '{print $1}' → Extract user column"
    echo "  • sort | uniq -c → Count per user"
    echo "  • sort -rn → Sort reverse numeric"
    echo "  • head -3 → Show top 3"
}

# ============ Menu ============
show_menu() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "TEXT EDITING & LINE CONTINUATION - 20 EXAMPLES"
    echo "════════════════════════════════════════════════════════"
    echo ""
    echo "BASIC SED & AWK:"
    echo "  1  - SED: Basic substitution"
    echo "  2  - SED: Global replacement"
    echo "  3  - SED: Delete lines"
    echo "  4  - SED: Print specific lines"
    echo "  5  - AWK: Extract columns"
    echo "  6  - AWK: Field separator"
    echo "  7  - AWK: Conditional processing"
    echo "  8  - AWK: Calculate totals"
    echo ""
    echo "LINE CONTINUATION & FORMATTING:"
    echo "  9  - Backslash continuation"
    echo "  10 - Pipe continuation (better readability)"
    echo "  11 - Multi-line if statements"
    echo "  12 - Multi-line command substitution"
    echo ""
    echo "ADVANCED EDITING:"
    echo "  13 - SED: Edit file in-place (-i)"
    echo "  14 - TR: Character translation"
    echo "  15 - Combine SED + AWK in pipeline"
    echo "  16 - CUT: Extract fields by position"
    echo "  17 - GREP: Regular expressions"
    echo ""
    echo "PRACTICAL DEVOPS:"
    echo "  18 - Log file analysis"
    echo "  19 - Config file editing"
    echo "  20 - Real DevOps script example"
    echo ""
    echo "  demo - Run examples 1-8 (quick demo)"
    echo "  all  - Run all 20 examples"
    echo ""
}

# ============ Main ============
main() {
    local choice="${1:-}"
    
    if [[ -z "$choice" ]]; then
        show_menu
        echo "Usage: $0 [1-20|demo|all]"
        echo ""
        echo "Example: $0 5"
        return 0
    fi
    
    case "$choice" in
        1)
            example_sed_basic
            ;;
        2)
            example_sed_global
            ;;
        3)
            example_sed_delete
            ;;
        4)
            example_sed_print
            ;;
        5)
            example_awk_columns
            ;;
        6)
            example_awk_separator
            ;;
        7)
            example_awk_condition
            ;;
        8)
            example_awk_sum
            ;;
        9)
            example_continuation_backslash
            ;;
        10)
            example_continuation_pipes
            ;;
        11)
            example_multiline_if
            ;;
        12)
            example_multiline_substitution
            ;;
        13)
            example_sed_inplace
            ;;
        14)
            example_tr_basic
            ;;
        15)
            example_combined_sed_awk
            ;;
        16)
            example_cut_command
            ;;
        17)
            example_grep_regex
            ;;
        18)
            example_practical_logs
            ;;
        19)
            example_practical_config
            ;;
        20)
            example_real_world_devops
            ;;
        demo)
            echo "Running examples 1-8..."
            for i in {1..8}; do
                case $i in
                    1) example_sed_basic ;;
                    2) example_sed_global ;;
                    3) example_sed_delete ;;
                    4) example_sed_print ;;
                    5) example_awk_columns ;;
                    6) example_awk_separator ;;
                    7) example_awk_condition ;;
                    8) example_awk_sum ;;
                esac
                sleep 0.5
            done
            ;;
        all)
            echo "Running all 20 examples..."
            for i in {1..20}; do
                case $i in
                    1) example_sed_basic ;;
                    2) example_sed_global ;;
                    3) example_sed_delete ;;
                    4) example_sed_print ;;
                    5) example_awk_columns ;;
                    6) example_awk_separator ;;
                    7) example_awk_condition ;;
                    8) example_awk_sum ;;
                    9) example_continuation_backslash ;;
                    10) example_continuation_pipes ;;
                    11) example_multiline_if ;;
                    12) example_multiline_substitution ;;
                    13) example_sed_inplace ;;
                    14) example_tr_basic ;;
                    15) example_combined_sed_awk ;;
                    16) example_cut_command ;;
                    17) example_grep_regex ;;
                    18) example_practical_logs ;;
                    19) example_practical_config ;;
                    20) example_real_world_devops ;;
                esac
                sleep 1
            done
            ;;
        *)
            echo "❌ Unknown option: $choice"
            show_menu
            ;;
    esac
    
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "✅ Example complete!"
    echo "════════════════════════════════════════════════════════"
}

main "$@"
