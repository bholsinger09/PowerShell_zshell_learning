#!/bin/zsh

# ═══════════════════════════════════════════════════════════════════════════════
# SED -n FLAG TUTORIAL
# Learn to use sed -n with real, runnable examples
# ═══════════════════════════════════════════════════════════════════════════════

# Create test file
TEST_FILE="/tmp/sed_tutorial_test.txt"
cat > "$TEST_FILE" << 'EOF'
Line 1: Apple
Line 2: Banana
Line 3: Cherry
Line 4: Date
Line 5: Elderberry
Line 6: Fig
Line 7: Grape
Line 8: Honeydew
Line 9: Kiwi
Line 10: Lemon
EOF

demo() {
    local num=$1
    
    case $num in
        1)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 1: WHAT DOES -n DO?"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "By default, sed prints EVERY line:"
            echo ""
            echo "Command: sed 's/Line/MODIFIED/' $TEST_FILE"
            echo ""
            echo "Result:"
            sed 's/Line/MODIFIED/' "$TEST_FILE"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ Notice: ALL 10 lines printed (with replacements)      ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        
        2)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 2: WHAT DOES -n DO? (PART 2)"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "The -n flag SUPPRESSES default output:"
            echo ""
            echo "Command: sed -n 's/Line/MODIFIED/' $TEST_FILE"
            echo ""
            echo "Result:"
            sed -n 's/Line/MODIFIED/' "$TEST_FILE"
            echo "(nothing!)"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ -n = 'Don't print anything by default'                ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        
        3)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 3: USING -n WITH 'p' (PRINT)"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Now combine -n with 'p' to print ONLY certain lines:"
            echo ""
            echo "Command: sed -n '3p' $TEST_FILE"
            echo "Meaning: sed -n = 'Be quiet' + '3p' = 'Print line 3'"
            echo ""
            echo "Result:"
            sed -n '3p' "$TEST_FILE"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ ✓ Only line 3 printed!                                ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        
        4)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 4: PRINT A DIFFERENT SINGLE LINE"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: sed -n '7p' $TEST_FILE"
            echo ""
            echo "Result:"
            sed -n '7p' "$TEST_FILE"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ ✓ Only line 7 printed!                                ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        
        5)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 5: PRINT A RANGE OF LINES"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: sed -n '2,5p' $TEST_FILE"
            echo "Meaning: Print lines 2 through 5"
            echo ""
            echo "Result:"
            sed -n '2,5p' "$TEST_FILE"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ ✓ Only lines 2, 3, 4, and 5 printed!                  ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        
        6)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 6: PRINT ANOTHER RANGE"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: sed -n '7,9p' $TEST_FILE"
            echo ""
            echo "Result:"
            sed -n '7,9p' "$TEST_FILE"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ ✓ Only lines 7, 8, and 9 printed!                     ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        
        7)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 7: PRINT TO END ($ = last line)"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: sed -n '8,\$p' $TEST_FILE"
            echo "Meaning: Print from line 8 to the last line (\$ = last line)"
            echo ""
            echo "Result:"
            sed -n '8,$p' "$TEST_FILE"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ ✓ Lines 8, 9, 10 (last 3 lines) printed!              ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        
        8)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 8: PRINT SPECIFIC LINES (not continuous)"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: sed -n '2p;5p;9p' $TEST_FILE"
            echo "Meaning: Print line 2, THEN line 5, THEN line 9"
            echo ""
            echo "Result:"
            sed -n '2p;5p;9p' "$TEST_FILE"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ ✓ Only lines 2, 5, and 9 printed (skip the rest!)    ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        
        9)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 9: PRINT LINES MATCHING PATTERN"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: sed -n '/Berry/p' $TEST_FILE"
            echo "Meaning: Print lines containing 'Berry'"
            echo ""
            echo "Result:"
            sed -n '/Berry/p' "$TEST_FILE"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ ✓ Only lines with 'Berry' in them printed!            ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        
        10)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 10: COMBINE -n WITH OTHER FLAGS"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "You can combine -n with substitution AND print:"
            echo ""
            echo "Command: sed -n '3s/Line/LINE/p' $TEST_FILE"
            echo "Meaning: On line 3, replace 'Line' with 'LINE' and print it"
            echo ""
            echo "Result:"
            sed -n '3s/Line/LINE/p' "$TEST_FILE"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ ✓ Only line 3 printed (and modified)!                 ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        
        11)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 11: EVERY OTHER LINE (step)"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: sed -n '1~2p' $TEST_FILE"
            echo "Meaning: Start at line 1, step by 2 (every other line)"
            echo ""
            echo "Result:"
            sed -n '1~2p' "$TEST_FILE"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ ✓ Every odd-numbered line printed!                    ║"
            echo "╚════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        
        12)
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "EXAMPLE 12: EVEN LINES"
            echo "════════════════════════════════════════════════════════"
            echo ""
            echo "Command: sed -n '2~2p' $TEST_FILE"
            echo "Meaning: Start at line 2, step by 2 (every other line)"
            echo ""
            echo "Result:"
            sed -n '2~2p' "$TEST_FILE"
            echo ""
            echo "╔════════════════════════════════════════════════════════╗"
            echo "║ ✓ Every even-numbered line printed!                   ║"
            echo "╚════════════════════════════════════════════════════════╝"
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
    echo "║        SED -n FLAG TUTORIAL - Learn by Examples               ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Usage: $0 <example_number>"
    echo ""
    echo "Examples:"
    echo "  1  - What does -n do?"
    echo "  2  - What does -n do? (Part 2)"
    echo "  3  - Using -n with 'p' (Print)"
    echo "  4  - Print a different single line"
    echo "  5  - Print a range of lines"
    echo "  6  - Print another range"
    echo "  7  - Print to end (\$ = last line)"
    echo "  8  - Print specific lines (not continuous)"
    echo "  9  - Print lines matching pattern"
    echo "  10 - Combine -n with other flags"
    echo "  11 - Every other line (odd)"
    echo "  12 - Every other line (even)"
    echo ""
    echo "  all - Show all examples"
    echo ""
    echo "Examples:"
    echo "  $0 1    # Show example 1"
    echo "  $0 5    # Show example 5"
    echo "  $0 all  # Show all 12 examples"
    echo ""
else
    demo "$1"
fi
