# 🎓 IF/THEN CONDITIONALS - REFERENCE CARD

## Quick Lookup (Print This!)

### Basic Syntax
```zsh
if [[ condition ]]; then
    commands
fi
```

### With Else
```zsh
if [[ condition ]]; then
    commands
else
    other commands
fi
```

### Multiple Choices
```zsh
if [[ condition1 ]]; then
    commands
elif [[ condition2 ]]; then
    commands
else
    commands
fi
```

---

## All Operators You Learned

### Numbers (-eq, -ne, -gt, -lt, -ge, -le)
| Operator | Means | Example |
|----------|-------|---------|
| -eq | Equal | `[[ 5 -eq 5 ]]` |
| -ne | Not equal | `[[ 5 -ne 3 ]]` |
| -gt | Greater than | `[[ 5 -gt 3 ]]` |
| -lt | Less than | `[[ 3 -lt 5 ]]` |
| -ge | Greater or equal | `[[ 5 -ge 5 ]]` |
| -le | Less or equal | `[[ 3 -le 5 ]]` |

### Strings (==, !=, =~, -z, -n)
| Operator | Means | Example |
|----------|-------|---------|
| == | String equals | `[[ "$A" == "$B" ]]` |
| != | String not equal | `[[ "$A" != "$B" ]]` |
| =~ | Regex match | `[[ "$A" =~ ^H ]]` |
| -z | String is empty | `[[ -z "$STR" ]]` |
| -n | String not empty | `[[ -n "$STR" ]]` |

### Files (-f, -d, -r, -w, -x, -s)
| Operator | Means | Example |
|----------|-------|---------|
| -f | Regular file exists | `[[ -f "$FILE" ]]` |
| -d | Directory exists | `[[ -d "$DIR" ]]` |
| -r | File is readable | `[[ -r "$FILE" ]]` |
| -w | File is writable | `[[ -w "$FILE" ]]` |
| -x | File is executable | `[[ -x "$FILE" ]]` |
| -s | File has content | `[[ -s "$FILE" ]]` |

### Logical (&&, ||, !)
| Operator | Means | Example |
|----------|-------|---------|
| && | AND (both true) | `[[ $A -gt 5 ]] && [[ $B -lt 10 ]]` |
| \|\| | OR (at least one true) | `[[ "$A" == "yes" ]] \|\| [[ "$B" == "yes" ]]` |
| ! | NOT (opposite) | `[[ ! -f "$FILE" ]]` |

---

## 12 Examples Summary

### Example 1: Basic if/then
Check if file exists, check if age > 18

### Example 2: if/else
Are you root? Is Python installed?

### Example 3: if/elif/else
Time-based greeting (morning/afternoon/evening/night)

### Example 4: Number comparisons
Show all -eq, -ne, -gt, -lt, -ge, -le operators

### Example 5: String comparisons
String equals, not equal, regex, empty check

### Example 6: File tests
Check -f, -d, -r, -w, -x, -s properties

### Example 7: AND/OR operators
Can drive (age && license)? Is it weekend (Sat || Sun)?

### Example 8: NOT operator
File does NOT exist, age is NOT 18+

### Example 9: PRACTICAL - Disk monitoring
Check disk usage, alert at different levels (GOOD/CAUTION/WARNING/CRITICAL)

### Example 10: PRACTICAL - Check running apps
Function to check if Finder/Safari/Terminal are running

### Example 11: INTERACTIVE - User input
Ask for age, validate input is number, categorize

### Example 12: ERROR CHECKING
Check if mkdir succeeds, check exit codes with $?

---

## Most Used Patterns

### 1. Check if file exists
```zsh
if [[ -f "$FILE" ]]; then
    echo "File exists"
else
    echo "File not found"
fi
```

### 2. Check if directory exists, create if not
```zsh
if [[ ! -d "$DIR" ]]; then
    mkdir -p "$DIR"
fi
```

### 3. Validate user input
```zsh
if [[ ! "$INPUT" =~ ^[0-9]+$ ]]; then
    echo "Please enter a number"
    exit 1
fi
```

### 4. Check if command succeeds
```zsh
if command_to_run; then
    echo "Success"
else
    echo "Failed"
    exit 1
fi
```

### 5. Multiple severity levels (monitoring)
```zsh
if [[ $VALUE -gt 90 ]]; then
    echo "CRITICAL"
elif [[ $VALUE -gt 75 ]]; then
    echo "WARNING"
elif [[ $VALUE -gt 50 ]]; then
    echo "CAUTION"
else
    echo "OK"
fi
```

### 6. Check if command exists
```zsh
if command -v python3 &>/dev/null; then
    echo "Python 3 installed"
else
    echo "Python 3 not found"
fi
```

### 7. Check multiple conditions
```zsh
if [[ $AGE -ge 16 ]] && [[ "$LICENSE" == "true" ]]; then
    echo "Can drive"
fi
```

### 8. Check if string is NOT empty
```zsh
if [[ -n "$USERNAME" ]]; then
    echo "Username: $USERNAME"
fi
```

---

## Key Concepts

- **[[ ... ]]** = Double brackets (use for conditions in zsh)
- **if/then/fi** = Must start with if and end with fi
- **else** = Alternative action if condition is FALSE
- **elif** = "else if" - another condition to check
- **$?** = Last command's exit code (0=success, non-zero=fail)
- **&&** = AND operator (all must be true)
- **||** = OR operator (at least one must be true)
- **!** = NOT operator (inverts the condition)

---

## What You've Mastered

✅ Basic if/then structures
✅ All comparison operators (numbers, strings, files)
✅ Logical operators (AND, OR, NOT)
✅ Nested conditions
✅ Real DevOps monitoring patterns
✅ Input validation
✅ Error handling with exit codes
✅ When to use each pattern

---

## Ready for Level 2?

Learn these next:
- **Loops**: Repeat actions multiple times
- **Functions**: Create reusable code blocks
- **File Operations**: Read and write files

File to check: `LEARNING_ADDONS.md` (Add-On 4, 5, 6)

---

## How to Use This Reference

1. **Bookmark this file** for quick lookup
2. **Print it** and keep by your desk
3. **Copy/paste patterns** into your scripts
4. **Test with examples** from the if-then script:
   ```zsh
   ./examples/basic/04-if-then-conditionals.zsh 1
   ./examples/basic/04-if-then-conditionals.zsh demo
   ```

---

## Remember

> "If/Then is how scripts make decisions"

Use it to:
- Validate input before processing
- Check system state before taking action
- Handle errors gracefully
- Build reliable automation

🚀 **You're ready to write real automation scripts!**
