#!/bin/zsh
#
# Script Name: 04-if-then-conditionals.zsh
# Description: Learn if/then statements - make decisions in your scripts
# Author: Learning Example
# Date: 2024-10-05
# Version: 1.0
#
# Usage: ./04-if-then-conditionals.zsh [option]
# Example: ./04-if-then-conditionals.zsh demo
#

set -euo pipefail

# ============ EXAMPLE 1: Basic If/Then ============
example_basic() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 1: BASIC IF/THEN"
    echo "════════════════════════════════════════════════════════"
    
    # Check if a file exists
    if [[ -f ~/.zshrc ]]; then
        echo "✅ .zshrc file exists"
    fi
    
    # Simple number comparison
    AGE=25
    if [[ $AGE -gt 18 ]]; then
        echo "✅ You are an adult (age: $AGE)"
    fi
}

# ============ EXAMPLE 2: If/Else ============
example_if_else() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 2: IF/ELSE - Two choices"
    echo "════════════════════════════════════════════════════════"
    
    USER_ID=$(id -u)
    
    if [[ $USER_ID -eq 0 ]]; then
        echo "✅ You are running as ROOT (user ID: 0)"
    else
        echo "ℹ️  You are a regular user (user ID: $USER_ID)"
    fi
    
    # Check if command exists
    if command -v python3 &> /dev/null; then
        echo "✅ Python 3 is installed"
    else
        echo "❌ Python 3 is NOT installed"
    fi
}

# ============ EXAMPLE 3: If/Elif/Else ============
example_if_elif_else() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 3: IF/ELIF/ELSE - Multiple choices"
    echo "════════════════════════════════════════════════════════"
    
    HOUR=$(date '+%H')
    HOUR=${HOUR#0}  # Remove leading zero
    
    if [[ $HOUR -lt 12 ]]; then
        echo "🌅 Good morning! (It's $HOUR:00)"
    elif [[ $HOUR -lt 17 ]]; then
        echo "☀️  Good afternoon! (It's $HOUR:00)"
    elif [[ $HOUR -lt 21 ]]; then
        echo "🌆 Good evening! (It's $HOUR:00)"
    else
        echo "🌙 Good night! (It's $HOUR:00)"
    fi
}

# ============ EXAMPLE 4: Comparison Operators ============
example_operators() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 4: COMPARISON OPERATORS"
    echo "════════════════════════════════════════════════════════"
    
    NUM=50
    
    echo "Number: $NUM"
    echo ""
    echo "Number comparisons:"
    
    if [[ $NUM -eq 50 ]]; then
        echo "  ✅ -eq   (equal)           : $NUM equals 50"
    fi
    
    if [[ $NUM -ne 100 ]]; then
        echo "  ✅ -ne   (not equal)       : $NUM does not equal 100"
    fi
    
    if [[ $NUM -gt 30 ]]; then
        echo "  ✅ -gt   (greater than)    : $NUM is greater than 30"
    fi
    
    if [[ $NUM -lt 100 ]]; then
        echo "  ✅ -lt   (less than)       : $NUM is less than 100"
    fi
    
    if [[ $NUM -ge 50 ]]; then
        echo "  ✅ -ge   (greater or equal): $NUM >= 50"
    fi
    
    if [[ $NUM -le 100 ]]; then
        echo "  ✅ -le   (less or equal)   : $NUM <= 100"
    fi
}

# ============ EXAMPLE 5: String Comparisons ============
example_string_comparisons() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 5: STRING COMPARISONS"
    echo "════════════════════════════════════════════════════════"
    
    NAME="Ben"
    
    if [[ "$NAME" == "Ben" ]]; then
        echo "✅ Name equals 'Ben'"
    fi
    
    if [[ "$NAME" != "Sarah" ]]; then
        echo "✅ Name does not equal 'Sarah'"
    fi
    
    if [[ "$NAME" =~ ^B ]]; then
        echo "✅ Name starts with 'B' (regex match)"
    fi
    
    if [[ -z "" ]]; then
        echo "✅ Empty string detected (using -z)"
    fi
    
    if [[ -n "Hello" ]]; then
        echo "✅ String is not empty (using -n)"
    fi
}

# ============ EXAMPLE 6: File Tests ============
example_file_tests() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 6: FILE TESTS - Check files and directories"
    echo "════════════════════════════════════════════════════════"
    
    TEST_FILE=~/.zshrc
    TEST_DIR=~/Documents
    
    # File exists
    if [[ -f $TEST_FILE ]]; then
        echo "✅ -f  : $TEST_FILE exists (regular file)"
    fi
    
    # Directory exists
    if [[ -d $TEST_DIR ]]; then
        echo "✅ -d  : $TEST_DIR exists (directory)"
    fi
    
    # File is readable
    if [[ -r $TEST_FILE ]]; then
        echo "✅ -r  : $TEST_FILE is readable"
    fi
    
    # File is writable
    if [[ -w $TEST_FILE ]]; then
        echo "✅ -w  : $TEST_FILE is writable"
    fi
    
    # File is executable
    if [[ -x /bin/bash ]]; then
        echo "✅ -x  : /bin/bash is executable"
    fi
    
    # File size > 0 (not empty)
    if [[ -s $TEST_FILE ]]; then
        echo "✅ -s  : $TEST_FILE is not empty"
    fi
}

# ============ EXAMPLE 7: Logical Operators (AND/OR) ============
example_logical_operators() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 7: LOGICAL OPERATORS - AND (&&) and OR (||)"
    echo "════════════════════════════════════════════════════════"
    
    AGE=25
    HAS_LICENSE=true
    
    # AND operator (&&) - both must be true
    if [[ $AGE -ge 16 ]] && [[ "$HAS_LICENSE" == "true" ]]; then
        echo "✅ Can drive: Age >= 16 AND has license"
    fi
    
    # OR operator (||) - at least one must be true
    WEEKEND=$(date '+%A')
    if [[ "$WEEKEND" == "Saturday" ]] || [[ "$WEEKEND" == "Sunday" ]]; then
        echo "✅ It's the weekend!"
    else
        echo "ℹ️  It's a weekday (today is $WEEKEND)"
    fi
    
    # Multiple conditions
    CPU_USAGE=45
    MEMORY_USAGE=60
    
    if [[ $CPU_USAGE -gt 80 ]] || [[ $MEMORY_USAGE -gt 85 ]]; then
        echo "⚠️  System resources are high"
    else
        echo "✅ System resources are normal"
    fi
}

# ============ EXAMPLE 8: Negation (NOT) ============
example_negation() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 8: NEGATION - Using ! (NOT)"
    echo "════════════════════════════════════════════════════════"
    
    # Check if file does NOT exist
    TEST_FILE=/nonexistent-file.txt
    
    if [[ ! -f $TEST_FILE ]]; then
        echo "✅ File does NOT exist: $TEST_FILE"
    fi
    
    # Negate a comparison
    AGE=16
    
    if [[ ! $AGE -ge 18 ]]; then
        echo "✅ Age is NOT 18 or older (age: $AGE)"
    fi
}

# ============ EXAMPLE 9: Practical Use Case - Check Disk Space ============
example_practical_disk() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 9: PRACTICAL - Check disk space"
    echo "════════════════════════════════════════════════════════"
    
    # Get disk usage percentage for home directory
    DISK_USAGE=$(df -h ~ | tail -1 | awk '{print $(NF-1)}' | sed 's/%//')
    
    echo "Home directory disk usage: ${DISK_USAGE}%"
    
    if [[ $DISK_USAGE -gt 90 ]]; then
        echo "🔴 CRITICAL: Disk usage is ${DISK_USAGE}% (above 90%)"
    elif [[ $DISK_USAGE -gt 75 ]]; then
        echo "🟠 WARNING: Disk usage is ${DISK_USAGE}% (above 75%)"
    elif [[ $DISK_USAGE -gt 50 ]]; then
        echo "🟡 CAUTION: Disk usage is ${DISK_USAGE}% (above 50%)"
    else
        echo "✅ GOOD: Disk usage is ${DISK_USAGE}% (below 50%)"
    fi
}

# ============ EXAMPLE 10: Practical Use Case - App Check ============
example_practical_app_check() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 10: PRACTICAL - Check if apps are running"
    echo "════════════════════════════════════════════════════════"
    
    # Function to check if process is running
    check_app() {
        local app_name=$1
        if pgrep "$app_name" > /dev/null 2>&1; then
            echo "✅ $app_name is running"
            return 0
        else
            echo "❌ $app_name is NOT running"
            return 1
        fi
    }
    
    echo "Checking for running applications:"
    check_app "Finder"
    check_app "Safari"
    check_app "Terminal"
}

# ============ EXAMPLE 11: Interactive User Input ============
example_interactive() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 11: INTERACTIVE - Make decisions based on user input"
    echo "════════════════════════════════════════════════════════"
    
    echo "What is your age?"
    read -r USER_AGE
    
    if [[ ! "$USER_AGE" =~ ^[0-9]+$ ]]; then
        echo "❌ Please enter a valid number"
        return 1
    fi
    
    if [[ $USER_AGE -lt 13 ]]; then
        echo "👶 You're a kid!"
    elif [[ $USER_AGE -lt 18 ]]; then
        echo "👦 You're a teenager!"
    elif [[ $USER_AGE -lt 65 ]]; then
        echo "👨 You're an adult!"
    else
        echo "👴 You're a senior!"
    fi
}

# ============ EXAMPLE 12: Error Checking ============
example_error_checking() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "EXAMPLE 12: ERROR CHECKING - Handle command failures"
    echo "════════════════════════════════════════════════════════"
    
    # Check if a command succeeds
    if mkdir -p ~/test-zshell-project 2>/dev/null; then
        echo "✅ Created directory successfully"
        
        # Clean up
        if rmdir ~/test-zshell-project 2>/dev/null; then
            echo "✅ Cleaned up test directory"
        fi
    else
        echo "❌ Failed to create directory"
    fi
    
    # Check exit code explicitly
    ls /nonexistent-directory 2>/dev/null
    EXIT_CODE=$?
    
    if [[ $EXIT_CODE -ne 0 ]]; then
        echo "❌ Command failed with exit code: $EXIT_CODE"
    fi
}

# ============ Main Menu ============
show_menu() {
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║         IF/THEN CONDITIONALS - LEARNING GUIDE          ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    echo "Choose an example to run:"
    echo ""
    echo "  1  - Basic if/then"
    echo "  2  - if/else (two choices)"
    echo "  3  - if/elif/else (multiple choices)"
    echo "  4  - Comparison operators (numbers)"
    echo "  5  - String comparisons"
    echo "  6  - File tests"
    echo "  7  - Logical operators (AND, OR)"
    echo "  8  - Negation (NOT)"
    echo "  9  - Practical: Check disk space"
    echo "  10 - Practical: Check running apps"
    echo "  11 - Interactive: User input"
    echo "  12 - Error checking"
    echo "  all - Run all examples"
    echo "  demo - Run examples 1-8 (quick demo)"
    echo ""
}

# ============ Main ============
main() {
    local choice="${1:-}"
    
    if [[ -z "$choice" ]]; then
        show_menu
        echo "Usage: $0 [1-12|all|demo]"
        echo ""
        echo "Example: $0 5"
        return 0
    fi
    
    case "$choice" in
        1)
            example_basic
            ;;
        2)
            example_if_else
            ;;
        3)
            example_if_elif_else
            ;;
        4)
            example_operators
            ;;
        5)
            example_string_comparisons
            ;;
        6)
            example_file_tests
            ;;
        7)
            example_logical_operators
            ;;
        8)
            example_negation
            ;;
        9)
            example_practical_disk
            ;;
        10)
            example_practical_app_check
            ;;
        11)
            example_interactive
            ;;
        12)
            example_error_checking
            ;;
        demo)
            example_basic
            example_if_else
            example_if_elif_else
            example_operators
            example_string_comparisons
            example_file_tests
            example_logical_operators
            example_negation
            ;;
        all)
            example_basic
            example_if_else
            example_if_elif_else
            example_operators
            example_string_comparisons
            example_file_tests
            example_logical_operators
            example_negation
            example_practical_disk
            example_practical_app_check
            example_practical_app_check
            example_error_checking
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
