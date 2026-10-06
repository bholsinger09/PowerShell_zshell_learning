# 📝 TEXT EDITING & LINE CONTINUATION - Quick Reference Guide

## Part 1: Text Editing from Command Line

### SED (Stream Editor)

SED is for finding and replacing text, deleting lines, and transforming files.

#### Basic Syntax
```bash
sed 's/pattern/replacement/' filename
```

#### Common SED Operations

| Operation | Syntax | Example |
|-----------|--------|---------|
| Replace (1st) | `sed 's/find/replace/'` | `sed 's/old/new/'` |
| Replace (all) | `sed 's/find/replace/g'` | `sed 's/old/new/g'` |
| Replace (2nd) | `sed 's/find/replace/2'` | `sed 's/old/new/2'` |
| Delete lines | `sed '/pattern/d'` | `sed '/error/d'` |
| Print lines | `sed -n 'p'` | `sed -n '1,5p'` |
| Print specific | `sed -n '3,7p'` | Only lines 3-7 |
| Edit in-place | `sed -i ''` | `sed -i '' 's/old/new/'` |
| With backup | `sed -i.bak` | `sed -i.bak 's/old/new/'` |
| Case-insensitive | `sed 's/pattern/replace/I'` | Ignore case |

#### Examples

```bash
# Replace first occurrence per line
sed 's/hello/goodbye/' file.txt

# Replace all occurrences per line
sed 's/hello/goodbye/g' file.txt

# Delete lines containing pattern
sed '/DELETE/d' file.txt

# Print only lines 3-7
sed -n '3,7p' file.txt

# Edit file in-place (macOS: needs empty string)
sed -i '' 's/old/new/g' file.txt

# Edit with backup
sed -i.bak 's/old/new/g' file.txt
# Creates file.txt.bak as backup
```

---

### AWK (Text Processing)

AWK processes data line-by-line, splitting lines into fields/columns.

#### Basic Syntax
```bash
awk 'pattern { action }' filename
# or
command | awk '{ action }'
```

#### Field Variables

| Variable | Meaning |
|----------|---------|
| `$0` | Entire line |
| `$1` | Column 1 |
| `$2` | Column 2 |
| `$NF` | Last column |
| `$(NF-1)` | Second-to-last column |
| `NF` | Number of fields/columns |

#### Common AWK Patterns

| Task | Syntax | Example |
|------|--------|---------|
| Extract column | `awk '{print $1}'` | First column |
| Extract 2 columns | `awk '{print $1, $3}'` | Columns 1 and 3 |
| Custom separator | `awk -F: '{print $1}'` | Use `:` as separator |
| Conditional | `awk '$2 > 30 {print}'` | If column 2 > 30 |
| Sum column | `awk '{sum += $1} END {print sum}'` | Total of column 1 |
| Count lines | `awk 'END {print NR}'` | Number of lines |
| Unique values | `awk '!seen[$0]++'` | Remove duplicates |

#### Examples

```bash
# Extract column 1
echo "John 30 engineer" | awk '{print $1}'
# Output: John

# Extract columns 1 and 3
echo "John 30 engineer" | awk '{print $1, $3}'
# Output: John engineer

# Use different field separator
echo "john:30:engineer" | awk -F: '{print $1, $3}'
# Output: john engineer

# Filter by condition
ps aux | awk '$3 > 50 {print $1, $3}'
# Show processes using over 50% CPU

# Sum values
echo -e "100\n200\n300" | awk '{sum += $1} END {print "Total:", sum}'
# Output: Total: 600

# Count lines
cat file.txt | awk 'END {print "Lines:", NR}'
```

---

### CUT (Extract Fields by Position)

CUT extracts specific columns/fields by position or delimiter.

#### Basic Syntax
```bash
cut -d delimiter -f fields filename
cut -c characters filename
```

#### CUT Options

| Option | Meaning | Example |
|--------|---------|---------|
| `-d:` | Use `:` as delimiter | `-d: -f1,3` |
| `-f1` | Extract field 1 | |
| `-f1,3` | Extract fields 1 and 3 | |
| `-f2-` | Extract from field 2 onward | |
| `-f1-5` | Extract fields 1 through 5 | |
| `-c1-5` | Extract characters 1-5 | |

#### Examples

```bash
# Extract fields by delimiter
echo "john:30:engineer:50000" | cut -d: -f1,4
# Output: john:50000

# Extract from field 2 onward
echo "john:30:engineer:50000" | cut -d: -f2-
# Output: 30:engineer:50000

# Extract characters
echo "hello world" | cut -c1-5
# Output: hello
```

---

### TR (Translate/Transform Characters)

TR replaces or removes characters.

#### Basic Syntax
```bash
tr 'from' 'to' < input
tr -d 'chars' < input    # Delete characters
tr -s 'chars' < input    # Squeeze duplicates
```

#### Examples

```bash
# Uppercase
echo "hello" | tr a-z A-Z
# Output: HELLO

# Lowercase
echo "HELLO" | tr A-Z a-z
# Output: hello

# Remove vowels
echo "hello world" | tr -d aeiouAEIOU
# Output: hll wrld

# Remove spaces
echo "hello world" | tr -d ' '
# Output: helloworld

# Replace colons with commas
echo "1:2:3:4" | tr ':' ','
# Output: 1,2,3,4
```

---

### GREP (Search Text)

GREP filters lines matching a pattern.

#### Basic Syntax
```bash
grep 'pattern' filename
command | grep 'pattern'
```

#### GREP Options

| Option | Meaning | Example |
|--------|---------|---------|
| `-i` | Case-insensitive | `grep -i "hello"` |
| `-v` | Invert (NOT matching) | `grep -v "error"` |
| `-E` | Extended regex | `grep -E "error\|warning"` |
| `-n` | Show line numbers | `grep -n "pattern"` |
| `-c` | Count matches | `grep -c "pattern"` |
| `-r` | Recursive (all files) | `grep -r "pattern" .` |

#### Examples

```bash
# Find lines with pattern
grep "error" app.log

# Case-insensitive
grep -i "ERROR" app.log

# Exclude lines
grep -v "DEBUG" app.log

# Count matches
grep -c "error" app.log
# Output: 5

# With line numbers
grep -n "error" app.log
```

---

## Part 2: Line Continuation

When commands are too long for one line, use line continuation.

### Method 1: Backslash `\`

Use `\` at end of line to continue on next line.

⚠️ **IMPORTANT:** Backslash MUST be the last character (no spaces after it).

#### Syntax
```bash
command1 \
    argument1 \
    argument2
```

#### Examples

```bash
# Basic example
ls -lah \
    | grep ".zsh" \
    | head -5

# Piping continues
echo "hello" \
    | sed 's/hello/goodbye/' \
    | tr a-z A-Z

# Condition with backslash
if [[ $value -gt 5 ]] && \
   [[ $value -lt 10 ]]; then
    echo "Between 5 and 10"
fi
```

### Method 2: Pipe at Beginning of Line

Put pipe `|` at the START of the next line (more readable).

#### Syntax
```bash
command1
| command2
| command3
```

#### Examples

```bash
# This is clearer than backslash
ls -1
| grep ".zsh"
| wc -l

# Log processing
cat app.log
| grep ERROR
| sed 's/ERROR://' 
| awk '{print $2}'
| sort
| uniq -c
```

### Method 3: Multi-line Strings

Use `()` for grouping statements across lines.

#### Syntax
```bash
(
    command1
    command2
    command3
)
```

#### Examples

```bash
# Grouped commands
(
    cd /tmp
    ls -la
    cd -
)

# If statement
if [[ -f "file.txt" ]]; then
    echo "Found file"
    cat file.txt
    echo "Done"
fi

# Command substitution
RESULT=$(
    ls -1
    | grep ".zsh"
    | wc -l
)
echo "Found $RESULT scripts"
```

---

## Part 3: Combining Techniques

### Chaining Text Tools

```bash
# Extract errors, clean format, count by type
cat app.log
| grep ERROR
| sed 's/.*ERROR: //'
| awk -F: '{print $1}'
| sort
| uniq -c
| sort -rn
```

### Multi-line Sed with Multiple Patterns

```bash
sed -e 's/old/new/g' \
    -e 's/foo/bar/g' \
    -e '/DELETE/d' \
    file.txt
```

### Complex Awk with Multiple Conditions

```bash
ps aux
| awk '$3 > 50 && $4 > 20 {
    printf "%s: CPU=%s%% MEM=%s%%\n", $1, $3, $4
}'
```

---

## Part 4: Real-World DevOps Examples

### Example 1: Log File Analysis

```bash
cat app.log
| grep ERROR
| sed 's/ERROR: //'
| awk -F' at ' '{print $2}'
| sort
| uniq -c
| sort -rn
```

### Example 2: Config File Editing

```bash
# Replace in config file (with backup)
sed -i.bak 's/ENVIRONMENT=dev/ENVIRONMENT=prod/' config.conf

# Extract all variables
grep "=" config.conf
| grep -v "^#"
```

### Example 3: System Monitoring

```bash
# Find high CPU processes
ps aux
| tail -n +2
| awk '$3 > 50 {print $1, $3, $11}'
| sort -k2 -rn
| head -10
```

### Example 4: User Report

```bash
# Count processes per user with details
ps aux
| tail -n +2
| awk '{print $1, $3, $4}'
| awk '{user=$1; cpu+=$2; mem+=$3} END {
    printf "Processes: %d | CPU: %.1f%% | Memory: %.1f%%\n",
    NR, cpu, mem
}'
```

### Example 5: Log Line Count by Type

```bash
cat app.log
| cut -d' ' -f3
| sort
| uniq -c
| sort -rn
```

---

## Part 5: Best Practices

### 1. **Test Before Editing**

```bash
# Test sed on copy first
sed 's/old/new/' file.txt > file_test.txt
# Check output
cat file_test.txt
# Then edit in-place if correct
sed -i '' 's/old/new/' file.txt
```

### 2. **Always Backup Original**

```bash
# Create backup
cp file.txt file.txt.bak
# Or use sed backup
sed -i.bak 's/old/new/' file.txt
```

### 3. **Use Proper Escaping in Sed**

```bash
# Escape special characters
sed 's/\/path\/to\/file/\/new\/path/' file.txt

# Or use different delimiter
sed 's|/path/to/file|/new/path|' file.txt
```

### 4. **Line Continuations with Pipes**

```bash
# GOOD: Pipes at start of line (clear intent)
command1
| command2
| command3

# AVOID: Pipes at end with backslash
command1 \
| command2 \
| command3
```

### 5. **Format Complex Awk**

```bash
# GOOD: Readable multi-line
ps aux
| awk '
    $3 > 50 {
        printf "%s: %s%%\n", $1, $3
    }
'

# AVOID: Single long line
ps aux | awk '$3 > 50 { printf "%s: %s%%\n", $1, $3 }'
```

---

## Part 6: Common Patterns

### Extract and Format

```bash
# Extract columns and format as CSV
cat data.txt
| cut -d: -f1,3,5
| tr ':' ','
```

### Filter and Count

```bash
# Count matching lines
cat app.log
| grep ERROR
| wc -l
```

### Search and Replace Multiple

```bash
# Multiple replacements
sed -i.bak \
    -e 's/old1/new1/g' \
    -e 's/old2/new2/g' \
    -e 's/old3/new3/g' \
    file.txt
```

### Conditional Processing

```bash
# Process lines by condition
awk '
    /pattern/ { print "MATCHED:", $0 }
    !/pattern/ { print "NO MATCH:", $0 }
'
```

---

## Quick Reference Card

```
SED:
  sed 's/find/replace/'     Replace first per line
  sed 's/find/replace/g'    Replace all per line
  sed -i '' 's/old/new/'    Edit in-place (macOS)
  sed '/pattern/d'          Delete lines
  sed -n '3,7p'             Print lines 3-7

AWK:
  awk '{print $1}'          Extract column 1
  awk '{print $1, $3}'      Extract columns 1 and 3
  awk -F: '{print $1}'      Use colon as separator
  awk '$2 > 30 {print}'     Conditional print
  awk '{sum += $1} END {print sum}'  Sum column 1

CUT:
  cut -d: -f1,3             Extract fields 1 and 3
  cut -c1-5                 Extract chars 1-5

TR:
  tr a-z A-Z                Uppercase
  tr -d ' '                 Remove spaces

GREP:
  grep "pattern"            Find matching lines
  grep -i "pattern"         Case-insensitive
  grep -v "pattern"         NOT matching

LINE CONTINUATION:
  command \                 Backslash at end
      argument
  
  command
  | next_command            Pipe at start of line
  
  (                         Grouping
      command
      | command
  )
```

---

## Resources

- Run examples: `./examples/basic/06-text-editing-and-line-continuation.zsh [1-20]`
- Check pipes reference: `cat PIPES_REFERENCE.md`
- Check if/then reference: `cat IF_THEN_REFERENCE.md`

---

## Summary

🎯 **Text Editing:** sed, awk, cut, tr, grep

🎯 **Line Continuation:** backslash `\`, pipes at start, grouping `()`

🎯 **Real DevOps:** Combine techniques for powerful automation!

Master these tools → Write efficient shell scripts → Automate everything! 🚀
