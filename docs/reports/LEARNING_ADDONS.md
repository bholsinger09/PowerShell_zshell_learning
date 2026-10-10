# 🎓 Zshell Learning Add-Ons - Type Manually!

Start with Level 1, then progress through the levels. Each example is complete and ready to paste into a script.

---

## ⭐ LEVEL 1: Basics (Easy!)

### Add-On 1️⃣: Command-Line Arguments

**What you'll learn:** Accept arguments when running your script

**Add this to hello-world.zsh:**

```zsh
#!/bin/zsh
# Your first script with arguments!

# Store arguments
SCRIPT_NAME="$0"
FIRST_ARG="${1:-World}"  # ${1:-World} means: use $1, or default to "World"
SECOND_ARG="${2:-Friend}"

echo "Hello, $FIRST_ARG and $SECOND_ARG!"
echo "Script name: $SCRIPT_NAME"
echo "You gave me: $@"  # All arguments
```

**How to run it:**
```zsh
./examples/basic/01-hello-world.zsh
./examples/basic/01-hello-world.zsh Ben
./examples/basic/01-hello-world.zsh Ben Sarah
```

---

### Add-On 2️⃣: User Input (Interactive)

**What you'll learn:** Ask the user for input

**Add this code:**

```zsh
#!/bin/zsh
# Ask user for their name

echo "What is your name?"
read -r USERNAME  # read stores input in USERNAME

echo "Nice to meet you, $USERNAME!"
echo "Today is $(date '+%A, %B %d, %Y')"
```

**Run it:**
```zsh
# Save to: examples/basic/03-user-input.zsh
# Then: chmod +x examples/basic/03-user-input.zsh
# Then: ./examples/basic/03-user-input.zsh
```

---

### Add-On 3️⃣: If/Then (Conditional Logic)

**What you'll learn:** Make decisions in your script

**Add this code:**

```zsh
#!/bin/zsh
# Check if user is admin

USER_ID=$(id -u)
echo "Your user ID is: $USER_ID"

if [[ $USER_ID -eq 0 ]]; then
    echo "✅ You are running as root (admin)!"
else
    echo "ℹ️  You are a regular user"
fi

# Check a file
if [[ -f ~/.zshrc ]]; then
    echo "✅ .zshrc file exists"
else
    echo "❌ .zshrc file not found"
fi
```

**Why you need this:** Control what your script does based on conditions

---

---

## 🚀 LEVEL 2: Intermediate (Getting Harder!)

### Add-On 4️⃣: Loops (Repeat Things)

**What you'll learn:** Do the same thing multiple times

**Add this code:**

```zsh
#!/bin/zsh
# Loop example

echo "=== Loop through numbers ==="
for i in {1..5}; do
    echo "Count: $i"
    sleep 0.5  # Wait half a second
done

echo ""
echo "=== Loop through files ==="
for file in ~/Documents/Zshell_Project/examples/basic/*.zsh; do
    echo "Found: $(basename "$file")"
done

echo ""
echo "=== While loop ==="
COUNTER=1
while [[ $COUNTER -le 3 ]]; do
    echo "Loop iteration: $COUNTER"
    ((COUNTER++))  # Increment counter
done
```

---

### Add-On 5️⃣: Functions You Create

**What you'll learn:** Reuse code by creating your own functions

**Add this code:**

```zsh
#!/bin/zsh
# Create your own functions

# Function to add two numbers
add() {
    local num1=$1
    local num2=$2
    local result=$((num1 + num2))
    echo "$num1 + $num2 = $result"
}

# Function to check if a process is running
is_running() {
    local process_name=$1
    if pgrep "$process_name" > /dev/null; then
        echo "✅ $process_name is running"
        return 0
    else
        echo "❌ $process_name is NOT running"
        return 1
    fi
}

# Use your functions
add 5 3
add 10 20

is_running "Safari"
is_running "Finder"
```

---

### Add-On 6️⃣: Working with Files

**What you'll learn:** Read, write, and manage files

**Add this code:**

```zsh
#!/bin/zsh
# File operations

# Create a file
echo "This is my first file" > ~/test-file.txt

# Read a file
echo "=== Reading file ==="
cat ~/test-file.txt

# Add to a file
echo "Adding more text" >> ~/test-file.txt

# Check if file exists
if [[ -f ~/test-file.txt ]]; then
    FILE_SIZE=$(wc -c < ~/test-file.txt)
    echo "File size: $FILE_SIZE bytes"
fi

# Count lines
LINE_COUNT=$(wc -l < ~/test-file.txt)
echo "Number of lines: $LINE_COUNT"

# Cleanup
rm ~/test-file.txt
echo "Cleaned up test file"
```

---

---

## 💪 LEVEL 3: Advanced (Expert Mode!)

### Add-On 7️⃣: Error Handling with Try/Catch Pattern

**What you'll learn:** Handle errors gracefully when things go wrong

**Add this code:**

```zsh
#!/bin/zsh
# Error handling

# Method 1: Check exit code
echo "Trying to list a file..."
if ls /nonexistent-file 2>/dev/null; then
    echo "✅ File found!"
else
    echo "❌ File not found (exit code: $?)"
fi

# Method 2: Trap errors
trap 'echo "❌ Error on line $LINENO!"; exit 1' ERR

# Method 3: Use || (OR) for fallback
RESULT=$(ls /nonexistent 2>&1) || RESULT="Default value"
echo "Result: $RESULT"

# Method 4: Safe variable access
OPTIONAL_VAR="${MISSING_VAR:-default_value}"
echo "Optional var: $OPTIONAL_VAR"
```

---

### Add-On 8️⃣: Arrays and Associative Arrays

**What you'll learn:** Store multiple values and look them up by name

**Add this code:**

```zsh
#!/bin/zsh
# Arrays - store multiple values

# Regular array (indexed by number)
FRUITS=("Apple" "Banana" "Orange" "Grape")

echo "=== Regular Array ==="
echo "First fruit: ${FRUITS[1]}"  # Zsh is 1-indexed!
echo "All fruits: ${FRUITS[@]}"
echo "Number of fruits: ${#FRUITS[@]}"

# Loop through array
for fruit in "${FRUITS[@]}"; do
    echo "  • $fruit"
done

# Associative array (like a dictionary)
typeset -A SERVERS
SERVERS[web]="192.168.1.10"
SERVERS[db]="192.168.1.20"
SERVERS[cache]="192.168.1.30"

echo ""
echo "=== Associative Array ==="
echo "Web server: ${SERVERS[web]}"
echo "All servers:"
for name in "${(@k)SERVERS[@]}"; do
    echo "  $name -> ${SERVERS[$name]}"
done
```

---

### Add-On 9️⃣: Running External Commands

**What you'll learn:** Run other commands and capture their output

**Add this code:**

```zsh
#!/bin/zsh
# Run external commands

# Simple command
echo "=== Today's date ==="
date

# Capture output in a variable
CURRENT_DATE=$(date '+%Y-%m-%d')
CURRENT_TIME=$(date '+%H:%M:%S')
echo "It is $CURRENT_TIME on $CURRENT_DATE"

# Run with options
echo ""
echo "=== List all running processes ==="
ps aux | head -5

# Count lines of output
LINE_COUNT=$(ls ~/Documents | wc -l)
echo "You have $LINE_COUNT items in Documents"

# Run multiple commands together
echo ""
echo "=== Run commands in sequence ==="
pwd && echo "Listing files:" && ls
```

---

### Add-On 🔟: String Manipulation

**What you'll learn:** Transform and manipulate text

**Add this code:**

```zsh
#!/bin/zsh
# String manipulation

# Store a string
TEXT="Hello Zshell World"

echo "=== String Operations ==="
echo "Original: $TEXT"
echo "Length: ${#TEXT}"
echo "Uppercase: ${TEXT:u}"
echo "Lowercase: ${TEXT:l}"

# Extract parts
SUBSTRING="${TEXT:0:5}"  # Get first 5 characters
echo "First 5 chars: $SUBSTRING"

# Find and replace
REPLACED="${TEXT//World/Script}"
echo "Replaced: $REPLACED"

# Check if string contains text
if [[ "$TEXT" == *"Zshell"* ]]; then
    echo "✅ Text contains 'Zshell'"
fi

# Split string
FILE_PATH="/Users/ben/Documents/file.txt"
FILENAME="${FILE_PATH##*/}"  # Get filename only
DIRECTORY="${FILE_PATH%/*}"  # Get directory only
echo "File: $FILENAME in $DIRECTORY"
```

---

---

## 🎯 BONUS: Real-World Add-On Ideas

### Add-On 11: System Monitoring Extension
Add these to `system-health-check.zsh`:
- Memory usage breakdown (apps consuming most RAM)
- Network stats (upload/download speeds)
- List top 5 CPU-consuming processes
- Check specific application status

### Add-On 12: Interactive Menu
Create a script that shows:
```
What do you want to do?
1) Check system health
2) Manage applications
3) View logs
4) Exit
```

### Add-On 13: Scheduled Monitoring
Create a script that:
- Runs health checks every 5 minutes
- Saves results to a file
- Alerts if thresholds are exceeded

### Add-On 14: Configuration File
Create `~/.zshell-config` that stores:
- Threshold values
- Email for alerts
- Log retention days
- App lists

### Add-On 15: Color & Formatting
Enhance output with:
- Color codes for different severity levels
- Tables and borders using Unicode
- Progress bars
- Emoji status indicators

---

---

## 🚀 HOW TO ADD THESE TO YOUR SCRIPTS

### Step 1: Open in Nano
```zsh
nano ~/Documents/Zshell_Project/examples/basic/01-hello-world.zsh
```

### Step 2: Scroll to end (Ctrl + End)
Move cursor to the bottom of the file

### Step 3: Add your code
Copy the example code and paste it

### Step 4: Save and Exit
- Press: Ctrl + X
- Type: Y (yes)
- Press: Enter

### Step 5: Make it executable
```zsh
chmod +x ~/Documents/Zshell_Project/examples/basic/01-hello-world.zsh
```

### Step 6: Run it
```zsh
./examples/basic/01-hello-world.zsh
```

---

## 💡 LEARNING PATH (Recommended Order)

**Week 1: Basics**
- Add-On 1: Command-line arguments
- Add-On 2: User input
- Add-On 3: If/Then conditionals

**Week 2: Intermediate**
- Add-On 4: Loops
- Add-On 5: Create functions
- Add-On 6: File operations

**Week 3: Advanced**
- Add-On 7: Error handling
- Add-On 8: Arrays
- Add-On 9: External commands

**Week 4+: Master**
- Add-On 10: String manipulation
- Bonus ideas: Real-world features
- Combine everything!

---

## 📚 TESTING YOUR CHANGES

Always test after editing:

```zsh
# Syntax check (catches errors)
zsh -n ~/Documents/Zshell_Project/examples/basic/01-hello-world.zsh

# Run your script
./examples/basic/01-hello-world.zsh

# View output
# If there's an issue, try:
bash -x ~/Documents/Zshell_Project/examples/basic/01-hello-world.zsh
# The -x flag shows each command as it runs
```

---

## ✅ WHAT TO PRACTICE

1. **Create new scripts** instead of editing existing ones
2. **Test each feature** as you add it
3. **Read error messages** - they tell you what's wrong
4. **Combine features** - use loops + functions + conditionals together
5. **Reference existing code** - look at system-health-check.zsh for patterns

---

## 🔗 REFERENCE LINKS

Check these files for real-world examples:
- `BEST_PRACTICES.md` - Professional patterns
- `scripts/lib/common-functions.sh` - 40+ reusable functions
- `scripts/monitoring/system-health-check.zsh` - Production example
- `scripts/applications/manage-applications.zsh` - Real app management

---

**Start with Level 1 today!** 🚀

