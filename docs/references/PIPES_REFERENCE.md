# 🔗 PIPES & COMMAND CHAINING - Quick Reference Guide

## What is a Pipe (|)?

A **pipe** connects two commands and sends the OUTPUT of the first command as INPUT to the second.

```
command1 | command2
```

### Basic Concept
- `command1` runs first and produces output
- `|` (pipe) captures that output
- `command2` receives the output as input
- Result is displayed on screen

### Example
```bash
ls | head -5
```
- `ls` lists all files
- `|` sends the list to head
- `head -5` shows only first 5 items

---

## 15 Essential Pipe Patterns

### 1️⃣ **Basic Pipe** - Connect two commands
```bash
ls | head -5
```
Filter output: show only first 5 files

### 2️⃣ **Multiple Pipes** - Chain many commands
```bash
ls | sort | head -5
```
1. List files
2. Sort alphabetically
3. Show first 5

### 3️⃣ **Count Lines** - Use `wc` (word count)
```bash
ls | wc -l
```
Count how many files in directory

**wc options:**
- `wc -l` = Count lines
- `wc -w` = Count words
- `wc -c` = Count characters/bytes

### 4️⃣ **Filter with grep** - Find matching lines
```bash
ls | grep script
```
Show only files containing "script"

**grep options:**
- `grep text` = Find exact text
- `grep -i text` = Case-insensitive
- `grep -v text` = Show lines WITHOUT text
- `grep -E regex` = Use regex patterns

### 5️⃣ **Search in Files** - grep inside files
```bash
grep -r "Description" *.zsh
```
Search for text in all zsh files

### 6️⃣ **Transform with sed** - Find and replace
```bash
echo -e "hello\nworld" | sed 's/hello/goodbye/g'
```
Replace "hello" with "goodbye"

**sed syntax:** `sed 's/from/to/g'`
- `s/` = substitute (find and replace)
- `/from/to/` = find "from", replace with "to"
- `g` = global (all occurrences, not just first)

### 7️⃣ **Process Each Line** - Use while read
```bash
ls -1 | head -3 | while read -r file; do
    echo "Processing: $file"
done
```
Read each line and process it individually

### 8️⃣ **Command Substitution** - Capture output in variable
```bash
FILE_COUNT=$(ls | wc -l)
echo "Found $FILE_COUNT files"
```
Run command, save result in variable: `VARIABLE=$(command)`

### 9️⃣ **Combine grep + awk** - Filter then extract
```bash
ps aux | grep Chrome | awk '{print $2}'
```
1. Show all processes (`ps aux`)
2. Find Chrome processes (`grep Chrome`)
3. Extract PID (column 2) with `awk`

**awk basics:**
- `awk '{print $1}'` = Print column 1
- `awk '{print $2}'` = Print column 2
- `awk -F: '{print $1}'` = Use `:` as separator, print column 1

### 🔟 **Sort and Filter** - Organize data
```bash
ps aux | grep -i "process" | head -3
```
Show top 3 matching processes

**sort options:**
- `sort` = Alphabetical
- `sort -r` = Reverse (Z→A)
- `sort -rh` = Reverse by size
- `sort -n` = Numeric

### 1️⃣1️⃣ **Remove Duplicates** - Use sort | uniq
```bash
echo -e "apple\nbanana\napple" | sort | uniq
```
Remove duplicate entries

⚠️ **Important:** Must `sort` BEFORE `uniq`, or duplicates won't be removed!

### 1️⃣2️⃣ **Redirect Output** - Save to file
```bash
ls | sort > output.txt      # Overwrite file
ls | sort >> output.txt     # Append to file
ls | sort 2> errors.txt     # Redirect errors
ls | sort &> all.txt        # Redirect output + errors
```

**Redirection symbols:**
- `>` = Write to file (overwrite)
- `>>` = Append to file
- `2>` = Redirect errors only
- `&>` = Redirect output + errors

### 1️⃣3️⃣ **Complex Pipe** - Multiple operations
```bash
du -sh */ | sort -rh | head -3
```
Find top 3 largest directories
1. `du -sh */` = Size of each directory
2. `sort -rh` = Sort by size, reverse
3. `head -3` = Show top 3

### 1️⃣4️⃣ **Practical: System Info** - Real DevOps automation
```bash
HOSTNAME=$(hostname)
USER=$(whoami)
CPU_CORES=$(system_profiler SPHardwareDataType | grep Cores | awk '{print $3}')
echo "System: $HOSTNAME | User: $USER | CPUs: $CPU_CORES"
```

### 1️⃣5️⃣ **Pipes + Conditionals** - Decision making
```bash
SCRIPT_COUNT=$(ls examples/basic/*.zsh | wc -l)

if [[ $SCRIPT_COUNT -gt 0 ]]; then
    echo "✅ Found $SCRIPT_COUNT scripts"
    ls examples/basic/*.zsh | sed 's|.*/||'
else
    echo "❌ No scripts found"
fi
```
Combine pipes with if/then for smart automation!

---

## Common Pipe Combinations

### 📊 Data Processing Pipeline
```bash
cat data.txt | grep "pattern" | awk '{print $2}' | sort | uniq | wc -l
```
1. Read file
2. Filter matching lines
3. Extract specific column
4. Sort
5. Remove duplicates
6. Count results

### 📁 Find Large Files
```bash
find . -type f -exec ls -lh {} \; | awk '{print $5, $9}' | sort -rh | head -10
```
Find top 10 largest files in directory

### 🔍 Search Across Files
```bash
grep -r "TODO" . | grep -v ".git" | awk -F: '{print $1}' | sort | uniq
```
Find all files with "TODO" comments (excluding git)

### 📈 System Monitoring
```bash
ps aux | grep -i app | awk '{sum += $6} END {print "Memory: " sum " KB"}'
```
Calculate total memory used by an app

### 🧹 Clean Up Logs
```bash
cat app.log | grep ERROR | awk '{print $2}' | sort | uniq -c | sort -rn
```
Find most common errors in log file

---

## Key Concepts

### 📝 stdout (Standard Output)
- Default output of a command
- Displayed on screen
- Sent through pipes

### 📥 stdin (Standard Input)
- Input to a command
- Comes from keyboard (or pipe)
- Read by right-hand command

### 📛 stderr (Standard Error)
- Error messages
- NOT sent through pipes by default
- Must use `2>` to redirect

### 🔄 Chaining
Connect multiple pipes:
```bash
command1 | command2 | command3 | command4
```
Each command receives input from previous one

---

## Real-World DevOps Examples

### 🔒 Find Open Ports
```bash
netstat -an | grep LISTEN | awk '{print $4}' | cut -d: -f2 | sort -u
```

### 🧾 Check Disk Space
```bash
df -h | awk 'NR>1 {print $1, $5}' | grep -v "^Filesystem"
```

### 📊 Monitor CPU Usage
```bash
top -l 1 | grep "CPU usage" | awk '{print $3}'
```

### 🔍 Find Recently Modified Files
```bash
find . -type f -mtime -1 | sort | head -20
```

### 🚀 Count Lines of Code
```bash
find . -name "*.zsh" -o -name "*.sh" | xargs wc -l | tail -1
```

---

## Debugging Tips

### 🐛 See what's flowing through pipe
```bash
# Without tee (normal pipe)
ls | wc -l

# With tee (see AND pass through)
ls | tee /tmp/debug.txt | wc -l
cat /tmp/debug.txt  # See what was piped
```

### 📍 Check each step
```bash
# Step 1
ls

# Step 2
ls | head -5

# Step 3
ls | head -5 | sort

# Final
ls | head -5 | sort | wc -l
```

### ✅ Verify pipe worked
```bash
# Save to file to inspect
ls | head -5 > output.txt
cat output.txt
```

---

## Practice Exercises

Try these to master pipes:

1. **Count how many files** have "config" in the name
   ```bash
   ls | grep config | wc -l
   ```

2. **Find longest filename**
   ```bash
   ls | awk '{print length, $0}' | sort -rn | head -1 | cut -d' ' -f2-
   ```

3. **Sort files by size**
   ```bash
   ls -lh | sort -k5 -h
   ```

4. **Count files by extension**
   ```bash
   ls | sed 's/.*\.//' | sort | uniq -c | sort -rn
   ```

5. **Find duplicates**
   ```bash
   ls | sort | uniq -d
   ```

---

## Common Mistakes to Avoid

❌ **WRONG:** `wc -l | ls`
- Pipes go LEFT to RIGHT
- Command order matters!

✅ **RIGHT:** `ls | wc -l`

---

❌ **WRONG:** `uniq data.txt`
- uniq needs sorted input
- Won't catch all duplicates

✅ **RIGHT:** `sort data.txt | uniq`

---

❌ **WRONG:** `grep pattern | wc`
- Missing file input to grep
- Need to provide input somehow

✅ **RIGHT:** `cat file.txt | grep pattern | wc -l`

---

## When to Use Each Tool

| Tool | Purpose | Example |
|------|---------|---------|
| `grep` | Filter/search lines | `ls \| grep .txt` |
| `awk` | Extract columns | `ps aux \| awk '{print $2}'` |
| `sed` | Find & replace | `echo "hello" \| sed 's/h/H/'` |
| `sort` | Sort data | `ls \| sort` |
| `uniq` | Remove duplicates | `sort file \| uniq` |
| `wc` | Count lines/words | `ls \| wc -l` |
| `head` | First N lines | `cat file \| head -5` |
| `tail` | Last N lines | `cat file \| tail -5` |
| `cut` | Extract columns | `cat file \| cut -d: -f1` |
| `tr` | Translate characters | `echo abc \| tr a-z A-Z` |

---

## Next Learning Steps

1. ✅ Learn pipes (YOU ARE HERE!)
2. Learn loops (for, while, until)
3. Learn functions (reusable code)
4. Learn arrays (store multiple values)
5. Master real DevOps automation

---

## Quick Reference Card

```
BASIC SYNTAX:
  command1 | command2

MULTIPLE PIPES:
  cmd1 | cmd2 | cmd3 | cmd4

WITH REDIRECTION:
  cmd1 | cmd2 > file.txt

WITH VARIABLES:
  RESULT=$(cmd1 | cmd2)
  echo $RESULT

WITH IF/THEN:
  if [[ $(ls | wc -l) -gt 5 ]]; then
      echo "Many files"
  fi

COMMON PATTERNS:
  ls | grep pattern       # Filter
  ls | wc -l             # Count
  ls | sort              # Sort
  ls | sort | uniq       # Unique
  ls | head -5           # First 5
  ls | tail -5           # Last 5
  ls | sed 's/a/b/g'    # Replace
  ps aux | awk '{print $2}'  # Extract column
```

---

## Resources

- Run examples: `./examples/basic/05-pipes-and-command-chaining.zsh [1-15]`
- View all if/then reference: `cat IF_THEN_REFERENCE.md`
- Check system monitoring: `./scripts/system-health-check.zsh`

---

## Summary

🔗 **Pipes are the heart of Unix/Linux command line**
- They let you chain commands together
- Each command processes the previous command's output
- This is how DevOps automation works!

Master pipes → Master the command line → Master system automation → Be a DevOps expert! 🚀

Good luck! 🎯
