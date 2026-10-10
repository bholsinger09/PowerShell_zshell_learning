# Practice Roadmap - Master the Tutorials

A structured guide to practice and master everything you've learned!

---

## 🎯 Overview

This roadmap gives you a complete practice plan:
- **Part 1:** SED -n Flag Mastery (15 min)
- **Part 2:** Command Substitution Mastery (15 min)
- **Part 3:** Text Editing Mastery (20 min)
- **Part 4:** Build Your Own Script (30 min)

**Total Time: About 90 minutes**

---

## 📚 Part 1: SED -n Flag Mastery (15 minutes)

### Step 1: Learn the Basics (5 min)

Open iTerm2 and run:

```bash
cd ~/Documents/Zshell_Project/examples/basic

# View the fundamentals
./07-sed-n-flag-tutorial.zsh 1
./07-sed-n-flag-tutorial.zsh 2
./07-sed-n-flag-tutorial.zsh 3
```

**Key Concepts:**
- `-n` = suppress default output (be quiet)
- `p` = print this line
- Together: `sed -n '3p'` = print line 3 only

### Step 2: See Practical Examples (5 min)

```bash
# View practical uses
./07-sed-n-flag-tutorial.zsh 5
./07-sed-n-flag-tutorial.zsh 7
./07-sed-n-flag-tutorial.zsh 9
```

### Step 3: Practice (5 min)

Run the first challenge:

```bash
./09-practice-challenges.zsh 1.1
```

This shows you:
- How to print line 5
- How to print lines 3-7
- How to print last 3 lines
- Real examples you can try yourself

**Try it:**
```bash
# Extract line 5 from your users file
sed -n '5p' /tmp/zshell_practice/users.txt
```

---

## 💡 Part 2: Command Substitution Mastery (15 minutes)

### Step 1: Learn the Basics (5 min)

```bash
# View fundamentals
./08-command-substitution-tutorial.zsh 1
./08-command-substitution-tutorial.zsh 2
./08-command-substitution-tutorial.zsh 3
```

**Key Concepts:**
- `VARIABLE=$(command)` = capture command output
- Store results for later use
- Use in if statements and messages

### Step 2: See Practical Examples (5 min)

```bash
# View practical uses
./08-command-substitution-tutorial.zsh 5
./08-command-substitution-tutorial.zsh 8
./08-command-substitution-tutorial.zsh 12
```

### Step 3: Practice (5 min)

Run the challenges:

```bash
./09-practice-challenges.zsh 2.1
./09-practice-challenges.zsh 2.2
```

**Try it yourself:**
```bash
# Store today's date
TODAY=$(date +%Y-%m-%d)
echo "Today is: $TODAY"

# Count files
COUNT=$(ls -1 /tmp/zshell_practice | wc -l)
echo "Files: $COUNT"

# Use in if statement
if [[ $COUNT -gt 2 ]]; then
    echo "More than 2 files!"
fi
```

---

## ✏️ Part 3: Text Editing Mastery (20 minutes)

### Step 1: Review All Tools (10 min)

```bash
# View all 20 examples
./06-text-editing-and-line-continuation.zsh all
```

This covers:
- SED (substitution, delete, print)
- AWK (field extraction, filtering, calculations)
- CUT (column extraction)
- TR (character transformation)
- GREP (pattern matching)

### Step 2: Practice Challenges (10 min)

```bash
./09-practice-challenges.zsh 3.1
./09-practice-challenges.zsh 3.2
```

**Try modifying data yourself:**

```bash
# Replace colons with pipes
sed 's/:/|/g' /tmp/zshell_practice/users.txt

# Extract names and salaries
cut -d: -f1,4 /tmp/zshell_practice/users.txt

# Find high earners
awk -F: '$4 > 70000 {print $1}' /tmp/zshell_practice/users.txt

# Calculate average
awk -F: '{sum+=$4; count++} END {print int(sum/count)}' /tmp/zshell_practice/users.txt
```

---

## 🚀 Part 4: Build Your Own Script (30 minutes)

Now it's time to create something from scratch!

### Challenge 4.1: Create a System Monitor Script

**Objective:** Create a script that reports system status

```bash
cat > /tmp/monitor.zsh << 'SCRIPT'
#!/bin/zsh

# System Monitor Script
# Uses command substitution and text editing to report system status

echo "════════════════════════════════════════════"
echo "SYSTEM STATUS REPORT"
echo "════════════════════════════════════════════"
echo ""

# Get current info
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
HOSTNAME=$(hostname)
UPTIME=$(uptime | awk '{print $1, $2, $3}' | sed 's/,//g')

echo "Date:      $DATE"
echo "Time:      $TIME"
echo "Host:      $HOSTNAME"
echo "Uptime:    $UPTIME"
echo ""

# Get disk usage
DISK_USAGE=$(df / | awk 'NR==2 {print $5}')
echo "Disk:      $DISK_USAGE"
echo ""

# Get process count
PROC_COUNT=$(ps aux | wc -l)
echo "Processes: $PROC_COUNT"
echo ""

echo "════════════════════════════════════════════"
SCRIPT

chmod +x /tmp/monitor.zsh
/tmp/monitor.zsh
```

### Challenge 4.2: Create a Log Analyzer Script

```bash
cat > /tmp/analyze_log.zsh << 'SCRIPT'
#!/bin/zsh

# Log Analyzer Script
# Analyzes logs and creates a report

LOG_FILE="${1:--}"  # Use stdin or argument

# Count log levels
ERROR=$(grep -c "ERROR" < <(cat "$LOG_FILE"))
WARNING=$(grep -c "WARNING" < <(cat "$LOG_FILE"))
INFO=$(grep -c "INFO" < <(cat "$LOG_FILE"))
TOTAL=$((ERROR + WARNING + INFO))

echo "╔════════════════════════════════════════╗"
echo "║       LOG ANALYSIS REPORT              ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "Errors:    $ERROR"
echo "Warnings:  $WARNING"
echo "Info:      $INFO"
echo "────────────────────────────────────────"
echo "Total:     $TOTAL"
echo ""

if [[ $ERROR -gt 0 ]]; then
    ERROR_PCT=$((ERROR * 100 / TOTAL))
    echo "⚠️  Error Rate: ${ERROR_PCT}%"
fi
SCRIPT

chmod +x /tmp/analyze_log.zsh
/tmp/analyze_log.zsh < /tmp/zshell_practice/system.log
```

---

## 📋 Practice Checklist

Mark off as you complete each section:

### SED -n FLAG
- [ ] Watched examples 1-3 (basics)
- [ ] Watched examples 5, 7, 9 (practical)
- [ ] Ran Challenge 1.1
- [ ] Tried extracting lines yourself
- [ ] Ran Challenge 1.2 (pattern matching)

### COMMAND SUBSTITUTION
- [ ] Watched examples 1-3 (basics)
- [ ] Watched examples 5, 8, 12 (practical)
- [ ] Ran Challenge 2.1
- [ ] Ran Challenge 2.2
- [ ] Tried storing variables yourself
- [ ] Used substitution in if statements

### TEXT EDITING
- [ ] Reviewed all 20 examples
- [ ] Ran Challenge 3.1
- [ ] Ran Challenge 3.2
- [ ] Tried sed commands yourself
- [ ] Tried awk commands yourself
- [ ] Tried cut commands yourself
- [ ] Analyzed logs yourself

### BUILD YOUR OWN
- [ ] Created system monitor script
- [ ] Created log analyzer script
- [ ] Modified scripts for different files
- [ ] Tested scripts with different inputs

---

## 🎓 Learning Tips

1. **Type, Don't Copy:** Always type commands manually (don't just copy/paste)
   - Builds muscle memory
   - You remember it better
   - You understand the syntax

2. **Experiment:** After understanding an example:
   - Try different patterns
   - Modify the data
   - See what breaks
   - Fix it

3. **Combine Tools:** Start with single tools:
   - `sed` alone
   - `awk` alone
   - `cut` alone
   
   Then combine them:
   - `sed | awk`
   - `grep | cut`
   - `sed | awk | cut`

4. **Read Error Messages:** When something fails:
   - Read the error carefully
   - Check syntax
   - Verify file paths
   - Try simpler version first

5. **Real-World Data:** Practice with actual data:
   - System logs in `/var/log/`
   - Config files
   - CSV files
   - Your own data

---

## 🔧 Common Commands to Memorize

```bash
# SED
sed 's/find/replace/'        # Substitute
sed 's/find/replace/g'       # Global replace
sed -n '3p' file             # Print line 3
sed -n '2,5p' file           # Print lines 2-5
sed '/ERROR/d' file          # Delete lines with ERROR

# AWK
awk '{print $1}' file        # Print first column
awk -F: '{print $1}' file    # Use colon delimiter
awk '$2 > 30' file           # Filter by condition
awk '{sum+=$1} END {print sum}' file  # Sum column

# CUT
cut -d: -f1 file             # Extract field 1
cut -d: -f1,4 file           # Extract fields 1 and 4
cut -c1-10 file              # Extract characters 1-10

# COMMAND SUBSTITUTION
VAR=$(command)               # Store command output
echo "Result: $VAR"          # Use the variable
COUNT=$(ls | wc -l)          # Count files
TODAY=$(date +%Y-%m-%d)      # Get today's date

# GREP
grep "pattern" file          # Find pattern
grep -c "pattern" file       # Count matches
grep -v "pattern" file       # Invert (NOT matching)
grep -i "pattern" file       # Case insensitive
```

---

## ✅ You're Ready When You Can:

- [ ] Explain what `-n` does in sed
- [ ] Write `sed -n '5p'` without looking it up
- [ ] Explain what `$()` does
- [ ] Create a variable with `COUNT=$(ls | wc -l)`
- [ ] Use that variable in an if statement
- [ ] Combine sed, awk, and grep in a pipeline
- [ ] Extract specific columns from CSV
- [ ] Write a script that analyzes logs
- [ ] Modify scripts to work with different files

---

## 🚀 Next: Level 5 - Loops & Functions

Once you complete this practice:
- You'll be ready for **for loops** (process multiple files)
- You'll be ready for **while loops** (monitor continuously)
- You'll be ready for **functions** (reusable code)
- You'll be ready to build **real automation scripts**

---

## 💬 Quick Reference

**Getting Help:**
```bash
# View any tutorial
./07-sed-n-flag-tutorial.zsh all
./08-command-substitution-tutorial.zsh all
./09-practice-challenges.zsh 1.1

# View just one example
./06-text-editing-and-line-continuation.zsh 5

# Check manual pages
man sed
man awk
man cut
man grep
```

**Practice Files:**
```bash
ls -la /tmp/zshell_practice/

# Contains:
# - users.txt (employee data)
# - system.log (log entries)
# - config.env (configuration)
# - sample_text.txt (text data)
```

**Your Scripts:**
```bash
cd ~/Documents/Zshell_Project/examples/basic

# Tutorials
./07-sed-n-flag-tutorial.zsh
./08-command-substitution-tutorial.zsh
./06-text-editing-and-line-continuation.zsh

# Practice challenges with solutions
./09-practice-challenges.zsh
```

---

## 📊 Progress Tracking

**Time Estimates:**
- Part 1 (SED -n): 15 min
- Part 2 (Substitution): 15 min
- Part 3 (Text Editing): 20 min
- Part 4 (Build Scripts): 30 min
- **Total: ~90 minutes**

**After completing all parts, you'll have:**
- ✅ Mastered text editing tools
- ✅ Mastered command substitution
- ✅ Created real automation scripts
- ✅ Confidence to build more
- ✅ Ready for Level 5 (Loops & Functions)

Happy practicing! 🎉
