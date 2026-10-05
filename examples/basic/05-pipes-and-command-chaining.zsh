#!/bin/zsh
#
# Script Name: 05-pipes-and-command-chaining.zsh
# Description: Learn how to combine commands using pipes and chains
# Author: Learning Example
# Date: 2024-10-05
# Version: 1.0
#
# Usage: ./05-pipes-and-command-chaining.zsh [1-15|demo|all]
#

set -euo pipefail

# ============ EXAMPLE 1: Basic Pipe ============
example_basic_pipe() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 1: BASIC PIPE - Connect two commands"
    echo "════════════════════════════════════════════════════════"
    
    echo "Files in this directory:"
    ls | head -5
    
    echo ""
    echo "Explanation:"
    echo "  ls              → Lists all files"
    echo "  |               → Pipe (send output to next command)"
    echo "  head -5         → Show only first 5 lines"
    echo ""
    echo "Result: Only first 5 files shown instead of all!"
}

# ============ EXAMPLE 2: Multiple Pipes ============
example_multiple_pipes() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 2: MULTIPLE PIPES - Chain many commands"
    echo "════════════════════════════════════════════════════════"
    
    echo "Files sorted by name:"
    ls | sort | head -5
    
    echo ""
    echo "Explanation:"
    echo "  ls              → List files"
    echo "  |               → Send to sort"
    echo "  sort            → Alphabetically sort the names"
    echo "  |               → Send to head"
    echo "  head -5         → Show first 5"
    echo ""
    echo "Flow: ls → sort → head -5"
}

# ============ EXAMPLE 3: Count Lines ============
example_count_lines() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 3: COUNTING - Use wc to count"
    echo "════════════════════════════════════════════════════════"
    
    FILE_COUNT=$(ls | wc -l)
    echo "✅ Number of files in directory: $FILE_COUNT"
    
    echo ""
    echo "Explanation:"
    echo "  ls              → List all files"
    echo "  |               → Send to wc"
    echo "  wc -l           → Count lines (-l means lines)"
    echo ""
    echo "Other wc options:"
    echo "  wc -l           → Count lines"
    echo "  wc -w           → Count words"
    echo "  wc -c           → Count characters/bytes"
}

# ============ EXAMPLE 4: Filter with grep ============
example_filter_grep() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 4: FILTERING - Use grep to find text"
    echo "════════════════════════════════════════════════════════"
    
    echo "Files containing 'script':"
    ls | grep script
    
    echo ""
    echo "Explanation:"
    echo "  ls              → List all files"
    echo "  |               → Send to grep"
    echo "  grep script     → Only show lines containing 'script'"
    echo ""
    echo "grep is for searching/filtering!"
}

# ============ EXAMPLE 5: Search in Content ============
example_search_content() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 5: SEARCH FILE CONTENT - grep inside files"
    echo "════════════════════════════════════════════════════════"
    
    echo "Looking for 'Description' in zsh files:"
    grep "Description" *.zsh 2>/dev/null | head -3
    
    echo ""
    echo "Explanation:"
    echo "  grep \"Description\" *.zsh"
    echo "                  → Find lines with 'Description' in .zsh files"
    echo "  |               → Send results to head"
    echo "  head -3         → Show only first 3 results"
}

# ============ EXAMPLE 6: Transform with sed ============
example_transform_sed() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 6: TRANSFORM - Use sed to modify text"
    echo "════════════════════════════════════════════════════════"
    
    echo "Replace 'example' with 'EXAMPLE':"
    echo -e "example one\nexample two\nexample three" | sed 's/example/EXAMPLE/g'
    
    echo ""
    echo "Explanation:"
    echo "  echo -e ...     → Output 3 lines"
    echo "  |               → Send to sed"
    echo "  sed 's/from/to/g' → Replace 'from' with 'to'"
    echo "                     g = global (all occurrences)"
    echo ""
    echo "sed is for find & replace!"
}

# ============ EXAMPLE 7: Processing Line by Line ============
example_process_lines() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 7: PROCESS LINES - while read loop with pipes"
    echo "════════════════════════════════════════════════════════"
    
    echo "Process each file name:"
    ls -1 | head -3 | while read -r filename; do
        echo "  ✓ Processing: $filename"
    done
    
    echo ""
    echo "Explanation:"
    echo "  ls -1               → List files (one per line)"
    echo "  |                   → Send to head"
    echo "  head -3             → Take first 3"
    echo "  |                   → Send to while"
    echo "  while read -r file  → Read each line into 'file' variable"
    echo "  do ... done         → Process each line"
}

# ============ EXAMPLE 8: Command Substitution ============
example_command_substitution() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 8: COMMAND SUBSTITUTION - Use output as input"
    echo "════════════════════════════════════════════════════════"
    
    CURRENT_DIR=$(pwd)
    echo "✅ Current directory: $CURRENT_DIR"
    
    FILE_COUNT=$(ls | wc -l)
    echo "✅ Contains $FILE_COUNT items"
    
    TOTAL_SIZE=$(du -sh . 2>/dev/null | awk '{print $1}')
    echo "✅ Total size: $TOTAL_SIZE"
    
    echo ""
    echo "Explanation:"
    echo "  VARIABLE=\$(command)  → Run command, save output in variable"
    echo "  pwd                   → Get current directory"
    echo "  ls | wc -l            → Count items"
    echo "  du -sh . | awk...     → Get directory size"
}

# ============ EXAMPLE 9: Combining grep and awk ============
example_grep_awk() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 9: GREP + AWK - Filter then extract"
    echo "════════════════════════════════════════════════════════"
    
    # Create sample data
    echo "Sample data (name:age:city):"
    echo "Ben:30:Seattle"
    echo "Sarah:28:Portland"
    echo "Mike:35:Seattle"
    
    echo ""
    echo "Extract just the names from Seattle:"
    echo -e "Ben:30:Seattle\nSarah:28:Portland\nMike:35:Seattle" | grep Seattle | awk -F: '{print $1}'
    
    echo ""
    echo "Explanation:"
    echo "  echo -e ...          → Output data"
    echo "  |                    → Send to grep"
    echo "  grep Seattle         → Find lines with 'Seattle'"
    echo "  |                    → Send to awk"
    echo "  awk -F: (print field1) → Extract field 1, -F: means field separator is ':'"
}

# ============ EXAMPLE 10: Sorting and Filtering ============
example_sort_filter() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 10: SORT + FILTER - Organize and filter data"
    echo "════════════════════════════════════════════════════════"
    
    echo "Process list sorted by name:"
    ps aux | grep -i "process" | head -3
    
    echo ""
    echo "Explanation:"
    echo "  ps aux              → Show all processes"
    echo "  |                   → Send to grep"
    echo "  grep -i \"process\"  → Find lines with 'process' (case insensitive)"
    echo "  |                   → Send to head"
    echo "  head -3             → Show first 3 matches"
}

# ============ EXAMPLE 11: Removing Duplicates ============
example_duplicates() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 11: REMOVE DUPLICATES - Use sort | uniq"
    echo "════════════════════════════════════════════════════════"
    
    echo "Original list (with duplicates):"
    echo -e "apple\nbanana\napple\ncherry\nbanana"
    
    echo ""
    echo "After removing duplicates:"
    echo -e "apple\nbanana\napple\ncherry\nbanana" | sort | uniq
    
    echo ""
    echo "Explanation:"
    echo "  echo -e ...    → Create list with duplicates"
    echo "  |              → Send to sort"
    echo "  sort           → Sort alphabetically"
    echo "  |              → Send to uniq"
    echo "  uniq           → Remove consecutive duplicates"
    echo ""
    echo "NOTE: Must sort BEFORE uniq, or uniq won't catch all duplicates!"
}

# ============ EXAMPLE 12: Redirect to File ============
example_redirect_file() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 12: REDIRECT OUTPUT - Save to file"
    echo "════════════════════════════════════════════════════════"
    
    OUTPUT_FILE="/tmp/zshell-demo-output.txt"
    
    # Create file
    ls | sort > "$OUTPUT_FILE"
    
    echo "✅ Created: $OUTPUT_FILE"
    echo "✅ Contains $(wc -l < "$OUTPUT_FILE") lines"
    
    echo ""
    echo "First 3 lines:"
    head -3 "$OUTPUT_FILE"
    
    echo ""
    echo "Explanation:"
    echo "  ls | sort > file    → Redirect output TO file"
    echo "  >                   → Overwrite file"
    echo "  >>                  → Append to file"
    echo "  2>                  → Redirect errors only"
    echo "  &>                  → Redirect output + errors"
}

# ============ EXAMPLE 13: Multiple Operations ============
example_complex_pipe() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 13: COMPLEX PIPE - Multiple operations"
    echo "════════════════════════════════════════════════════════"
    
    echo "Find large directories:"
    du -sh */ 2>/dev/null | sort -rh | head -3
    
    echo ""
    echo "Explanation:"
    echo "  du -sh */           → Size of each subdirectory"
    echo "  |                   → Send to sort"
    echo "  sort -rh            → Sort reverse (-r) human-readable (-h)"
    echo "  |                   → Send to head"
    echo "  head -3             → Show top 3"
    echo ""
    echo "Real-world use: Find what's taking up disk space!"
}

# ============ EXAMPLE 14: Practical - Log Analysis ============
example_log_analysis() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 14: PRACTICAL - Analyze system info"
    echo "════════════════════════════════════════════════════════"
    
    echo "System information:"
    echo "✅ Hostname: $(hostname)"
    echo "✅ Current user: $(whoami)"
    echo "✅ CPU cores: $(sysctl -n hw.ncpu 2>/dev/null || echo 'N/A')"
    
    UPTIME=$(uptime | awk '{print $1}')
    echo "✅ Uptime command works: $UPTIME"
    
    echo ""
    echo "Explanation:"
    echo "  \$(hostname)              → Get hostname"
    echo "  \$(whoami)                → Get current user"
    echo "  \$(uptime | awk '{...}')  → Parse uptime output"
}

# ============ EXAMPLE 15: Chaining with Conditionals ============
example_chain_conditionals() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 15: PIPES + CONDITIONALS - Real automation!"
    echo "════════════════════════════════════════════════════════"
    
    ZSHELL_SCRIPTS=$(ls examples/basic/*.zsh 2>/dev/null | wc -l)
    
    if [[ $ZSHELL_SCRIPTS -gt 0 ]]; then
        echo "✅ Found $ZSHELL_SCRIPTS Zshell scripts"
        
        echo ""
        echo "Scripts:"
        ls examples/basic/*.zsh 2>/dev/null | sed 's/.*\//  ✓ /'
    else
        echo "❌ No Zshell scripts found"
    fi
    
    echo ""
    echo "Explanation:"
    echo "  ls | wc -l           → Count files with pipe"
    echo "  if [[ count -gt 0 ]] → Make decision based on pipe result"
    echo "  ls | sed              → Transform output with pipe"
    echo ""
    echo "This shows how pipes work with if/then logic!"
}

# ============ Main Menu ============
show_menu() {
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║      PIPES & COMMAND CHAINING - LEARNING GUIDE         ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    echo "Choose an example to run:"
    echo ""
    echo "  1  - Basic pipe (ls | head)"
    echo "  2  - Multiple pipes (ls | sort | head)"
    echo "  3  - Count lines with wc"
    echo "  4  - Filter with grep"
    echo "  5  - Search file content"
    echo "  6  - Transform with sed"
    echo "  7  - Process lines (while read)"
    echo "  8  - Command substitution (use output as variable)"
    echo "  9  - grep + awk combination"
    echo "  10 - Sort and filter data"
    echo "  11 - Remove duplicates (sort | uniq)"
    echo "  12 - Redirect output to file (>)"
    echo "  13 - Complex pipe (multiple operations)"
    echo "  14 - Practical: System information"
    echo "  15 - Pipes + Conditionals (real automation!)"
    echo "  demo - Run examples 1-8 (quick demo)"
    echo "  all  - Run all 15 examples"
    echo ""
}

# ============ Main ============
main() {
    local choice="${1:-}"
    
    if [[ -z "$choice" ]]; then
        show_menu
        echo "Usage: $0 [1-15|demo|all]"
        echo ""
        echo "Example: $0 5"
        return 0
    fi
    
    case "$choice" in
        1)
            example_basic_pipe
            ;;
        2)
            example_multiple_pipes
            ;;
        3)
            example_count_lines
            ;;
        4)
            example_filter_grep
            ;;
        5)
            example_search_content
            ;;
        6)
            example_transform_sed
            ;;
        7)
            example_process_lines
            ;;
        8)
            example_command_substitution
            ;;
        9)
            example_grep_awk
            ;;
        10)
            example_sort_filter
            ;;
        11)
            example_duplicates
            ;;
        12)
            example_redirect_file
            ;;
        13)
            example_complex_pipe
            ;;
        14)
            example_log_analysis
            ;;
        15)
            example_chain_conditionals
            ;;
        demo)
            example_basic_pipe
            example_multiple_pipes
            example_count_lines
            example_filter_grep
            example_search_content
            example_transform_sed
            example_process_lines
            example_command_substitution
            ;;
        all)
            example_basic_pipe
            example_multiple_pipes
            example_count_lines
            example_filter_grep
            example_search_content
            example_transform_sed
            example_process_lines
            example_command_substitution
            example_grep_awk
            example_sort_filter
            example_duplicates
            example_redirect_file
            example_complex_pipe
            example_log_analysis
            example_chain_conditionals
            ;;
        *)
            echo "❌ Unknown option: $choice"
            show_menu
            return 1
            ;;
    esac
    
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "✅ Example complete!"
    echo "════════════════════════════════════════════════════════"
}

main "$@"
