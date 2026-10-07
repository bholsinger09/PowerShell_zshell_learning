#!/bin/zsh

# Interactive SED -n Flag Tutorial
# A hands-on learning experience with guided prompts
# Usage: ./07-sed-n-interactive.zsh

set -e

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Setup test data
TESTFILE="/tmp/sed_tutorial_test.txt"
cat > "$TESTFILE" << 'EOF'
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

# Function to pause and wait for user
wait_for_user() {
    echo ""
    echo -e "${YELLOW}Press ENTER to continue...${NC}"
    read -r
}

# Function to show a prompt and execute command
show_prompt() {
    local description="$1"
    local command="$2"
    
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} $description"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Command to type:${NC}"
    echo -e "${GREEN}$command${NC}"
    echo ""
    echo -e "${YELLOW}Press ENTER when ready to see the result...${NC}"
    read -r
    echo ""
    echo -e "${YELLOW}Result:${NC}"
    eval "$command"
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

# Main tutorial
clear

echo -e "${GREEN}"
cat << 'EOF'
╔════════════════════════════════════════════════════════╗
║                                                        ║
║   INTERACTIVE SED -n FLAG TUTORIAL                   ║
║   Learn by typing commands yourself                   ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "${YELLOW}This tutorial will guide you through each concept.${NC}"
echo "You'll type commands and see their results immediately."
echo ""
echo "Test file location: $TESTFILE"
echo ""
wait_for_user

# ============ EXAMPLE 1 ============
explain "EXAMPLE 1: What does -n do?" \
"By default, sed prints EVERY line in the file.
With -n, sed SUPPRESSES default printing.
Combined with 'p' command, you print only SPECIFIC lines.

Let's see both:"

show_prompt "Step 1: WITHOUT -n (prints everything with substitution)" \
"sed 's/Line/MODIFIED/' $TESTFILE | head -5"

wait_for_user

show_prompt "Step 2: WITH -n (no output - notice nothing prints!)" \
"sed -n 's/Line/MODIFIED/' $TESTFILE"

wait_for_user

show_prompt "Step 3: WITH -n AND 'p' (now print only what matches)" \
"sed -n 's/Line/MODIFIED/p' $TESTFILE | head -5"

wait_for_user

explain "KEY CONCEPT:" \
"WITHOUT -n:   sed prints EVERY line (modified or not)
WITH -n alone: sed prints NOTHING
WITH -n + p:   sed prints ONLY the modified lines"

wait_for_user

# ============ EXAMPLE 2 ============
explain "EXAMPLE 2: Print a SINGLE line" \
"The '3p' address means 'line 3'.
With -n, print only line 3."

show_prompt "Type this to print ONLY line 3:" \
"sed -n '3p' $TESTFILE"

wait_for_user

explain "WHAT HAPPENED:" \
"sed -n '3p' means:
  -n = suppress default output
  3p = print line 3

Only line 3 appears!"

wait_for_user

# ============ EXAMPLE 3 ============
explain "EXAMPLE 3: Print a RANGE of lines" \
"The '2,5p' means 'lines 2 through 5'.
With -n, print only those lines."

show_prompt "Type this to print lines 2-5:" \
"sed -n '2,5p' $TESTFILE"

wait_for_user

explain "WHAT HAPPENED:" \
"sed -n '2,5p' means:
  -n = suppress default output
  2,5p = print lines 2 through 5

Only lines 2-5 appear!"

wait_for_user

# ============ EXAMPLE 4 ============
explain "EXAMPLE 4: Print lines MATCHING a pattern" \
"Instead of line numbers, use /PATTERN/p to print matching lines.
This is powerful for finding specific content."

show_prompt "Type this to print only lines with 'e' in them:" \
"sed -n '/e/p' $TESTFILE"

wait_for_user

explain "WHAT HAPPENED:" \
"sed -n '/e/p' means:
  -n = suppress default output
  /e/p = print lines containing 'e'

Notice: Apple, Honeydew, Elderberry, Cherry, Lemon all contain 'e'"

wait_for_user

# ============ EXAMPLE 5 ============
explain "EXAMPLE 5: Print lines NOT matching a pattern" \
"Use ! to invert the match.
/pattern/! means 'lines NOT matching the pattern'"

show_prompt "Type this to print only lines WITHOUT 'a':" \
"sed -n '/a/!p' $TESTFILE"

wait_for_user

explain "WHAT HAPPENED:" \
"sed -n '/a/!/p' means:
  -n = suppress default output
  /a/! = lines NOT containing 'a'
  p = print them

Banana, Date, Cherry don't appear because they contain 'a'"

wait_for_user

# ============ EXAMPLE 6 ============
explain "EXAMPLE 6: Print lines 1, 5, and 10" \
"Use multiple addresses separated by semicolons."

show_prompt "Type this to print specific lines:" \
"sed -n '1p;5p;10p' $TESTFILE"

wait_for_user

explain "WHAT HAPPENED:" \
"sed -n '1p;5p;10p' means:
  -n = suppress default output
  1p = print line 1
  5p = print line 5
  10p = print line 10

Each command separated by semicolon."

wait_for_user

# ============ EXAMPLE 7 ============
explain "EXAMPLE 7: Print from line 5 to the LAST line" \
"Use $ to represent the last line.
'5,$p' means 'line 5 through the end'"

show_prompt "Type this to print lines 5-10:" \
"sed -n '5,\$p' $TESTFILE"

wait_for_user

explain "WHAT HAPPENED:" \
"sed -n '5,\$p' means:
  -n = suppress default output
  5,\$ = from line 5 to the last line ($)

Notice we needed \\ to escape $ in the command"

wait_for_user

# ============ EXAMPLE 8 ============
explain "EXAMPLE 8: COMBINING with substitution" \
"You can substitute ONLY specific lines using -n and addresses.
Print and replace only matching lines."

show_prompt "Type this to replace only in lines 3-7:" \
"sed -n '3,7s/Line/ITEM/p' $TESTFILE"

wait_for_user

explain "WHAT HAPPENED:" \
"sed -n '3,7s/Line/ITEM/p' means:
  -n = suppress default output
  3,7 = only in lines 3-7
  s/Line/ITEM/p = substitute AND print matching lines

Only lines 3-7 appear with ITEM instead of Line"

wait_for_user

# ============ PRACTICE TIME ============
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} YOUR TURN: PRACTICE TIME"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

echo "Try these challenges. Look at $TESTFILE if you need to:"
echo ""
echo "Challenge 1: Print only line 7"
echo "Expected: Line 7: Grape"
echo ""
echo -e "${YELLOW}Type your command:${NC}"
read -r user_cmd1
echo ""
echo -e "${YELLOW}Result:${NC}"
eval "$user_cmd1" || echo "Command failed"

echo ""
echo "Challenge 2: Print all lines containing 'Line 1' (beginning, not in middle)"
echo "Expected: Line 1, Line 10"
echo ""
echo -e "${YELLOW}Type your command:${NC}"
read -r user_cmd2
echo ""
echo -e "${YELLOW}Result:${NC}"
eval "$user_cmd2" || echo "Command failed"

echo ""
echo "Challenge 3: Print lines 4-6 AND line 9"
echo "Expected: Line 4, Line 5, Line 6, Line 9"
echo ""
echo -e "${YELLOW}Type your command:${NC}"
read -r user_cmd3
echo ""
echo -e "${YELLOW}Result:${NC}"
eval "$user_cmd3" || echo "Command failed"

# ============ SUMMARY ============
echo ""
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} SUMMARY: What You Learned"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
cat << 'EOF'
sed -n Flag Patterns:

  sed -n '3p' file              Print line 3
  sed -n '2,5p' file            Print lines 2-5
  sed -n '5,$p' file            Print line 5 to end
  sed -n '/pattern/p' file      Print lines matching pattern
  sed -n '/pattern/!p' file     Print lines NOT matching pattern
  sed -n '1p;5p;10p' file       Print specific lines (1, 5, 10)
  sed -n '3,7s/old/new/p' file  Substitute and print only lines 3-7

KEY CONCEPT:
  -n = suppress all output
  p = print (use with -n to print ONLY what you specify)

REMEMBER:
  Without -n, sed prints EVERYTHING
  With -n, sed prints NOTHING unless you use 'p'
  With -n + p, sed prints ONLY what you specify
EOF

echo ""
echo -e "${YELLOW}Congratulations! You've completed the interactive tutorial! 🎉${NC}"
echo ""
