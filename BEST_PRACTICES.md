# Zshell Scripting Best Practices

## 1. Script Header & Documentation

Always start your scripts with a clear header:

```zsh
#!/bin/zsh
#
# Script Name: example-script.zsh
# Description: Brief description of what the script does
# Author: Your Name
# Date: YYYY-MM-DD
# Version: 1.0
#
# Usage: ./example-script.zsh [OPTIONS]
# Example: ./example-script.zsh --verbose
#

set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

## 2. Error Handling

Always handle errors gracefully:

```zsh
# Set error trap
trap 'echo "Error on line $LINENO"; exit 1' ERR

# Use error handling function
error() {
    echo "ERROR: $*" >&2
    exit 1
}

warn() {
    echo "WARNING: $*" >&2
}

info() {
    echo "INFO: $*"
}
```

## 3. Variable Declaration

Use explicit variable names and provide defaults:

```zsh
# Declare variables clearly
local script_dir="${0:a:h}"
local log_file="${HOME}/.logs/script.log"
local verbose="${VERBOSE:-false}"
local dry_run="${DRY_RUN:-false}"
```

## 4. Functions

Break scripts into reusable functions:

```zsh
# Good: Clear function name and documentation
check_prerequisites() {
    # Description: Verify all required commands exist
    local required_commands=("python3" "git" "curl")
    
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" > /dev/null 2>&1; then
            error "Required command not found: $cmd"
        fi
    done
}

# Bad: Vague naming, no documentation
do_stuff() {
    # ... unclear what this does
}
```

## 5. Logging

Always log important actions:

```zsh
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$level] $message" | tee -a "$log_file"
}

log "INFO" "Script started"
log "WARN" "Low disk space"
log "ERROR" "Failed to complete task"
```

## 6. Input Validation

Always validate inputs:

```zsh
# Check command existence
if ! command -v "some_command" > /dev/null 2>&1; then
    error "Command 'some_command' not found. Please install it."
fi

# Check file exists
if [[ ! -f "$file_path" ]]; then
    error "File not found: $file_path"
fi

# Check directory exists
if [[ ! -d "$dir_path" ]]; then
    error "Directory not found: $dir_path"
fi

# Validate number
if ! [[ "$value" =~ ^[0-9]+$ ]]; then
    error "Value must be a number: $value"
fi
```

## 7. Conditional Execution (Dry Run)

Provide dry-run capability:

```zsh
execute() {
    if [[ "$dry_run" == "true" ]]; then
        echo "[DRY RUN] Would execute: $*"
    else
        "$@" || error "Command failed: $*"
    fi
}

# Usage:
execute rm -f /path/to/file
```

## 8. macOS-Specific Considerations

```zsh
# Get OS version
os_version=$(sw_vers -productVersion)

# Check if running on Apple Silicon (M1/M2/M3)
if [[ $(uname -m) == "arm64" ]]; then
    echo "Running on Apple Silicon"
else
    echo "Running on Intel"
fi

# Use `open` command for macOS
open -a "Application Name" path/to/file

# Access System Preferences values
defaults read com.apple.dock persistent-apps

# Schedule with launchd (better than cron on macOS)
# See config/startup-launchd/ for examples
```

## 9. Performance Considerations

```zsh
# Use local variables to avoid global pollution
function my_function() {
    local var1="value1"
    local var2="value2"
}

# Cache command output if used multiple times
local disk_usage
disk_usage=$(df -h / | tail -1)

# Use process substitution instead of subshells when possible
while IFS= read -r line; do
    process_line "$line"
done < <(get_data)

# Avoid unnecessary loops
# Bad:
for file in $(find . -name "*.txt"); do
    process "$file"
done

# Good:
find . -name "*.txt" -print0 | xargs -0 -I {} process "{}"
```

## 10. Security Best Practices

```zsh
# Use local variables
function secure_function() {
    local password  # Don't expose sensitive data globally
}

# Quote variables to prevent word splitting
echo "$file_path"  # Good
echo $file_path    # Bad - prone to expansion issues

# Be careful with eval (generally avoid)
# Bad:
eval "command $user_input"

# Good:
command "$user_input"

# Check file permissions before executing
if [[ ! -x "$script_path" ]]; then
    chmod +x "$script_path" || error "Cannot make script executable"
fi

# Use explicit paths
/usr/bin/env python3  # Good
python3               # May not work in all contexts
```

## 11. Exit Codes

Use meaningful exit codes:

```zsh
# 0 = Success
# 1 = General error
# 2 = Misuse of shell command
# 126 = Command invoked cannot execute
# 127 = Command not found
# 128+ = Fatal error signal

exit 0  # Success
exit 1  # General error
exit 2  # Misuse of command
```

## 12. Testing Your Scripts

```zsh
# Use shellcheck to lint scripts
shellcheck script.zsh

# Test with different inputs
./script.zsh --help
./script.zsh --verbose
./script.zsh --dry-run

# Test error conditions
./script.zsh --invalid-arg

# Test with different shells
bash script.sh  # If shell agnostic
zsh script.zsh
```

## 13. Documentation

- Always include inline comments for complex logic
- Document function parameters and return values
- Keep a CHANGELOG for version updates
- Include usage examples in script help
- Document any dependencies and requirements

## Quick Reference

```zsh
# Script template
#!/bin/zsh
set -euo pipefail
trap 'echo "Error on line $LINENO"; exit 1' ERR

# Logging functions
error() { echo "ERROR: $*" >&2; exit 1; }
warn() { echo "WARNING: $*" >&2; }
info() { echo "INFO: $*"; }

# Check prerequisites
if ! command -v required_cmd > /dev/null 2>&1; then
    error "Required command not found: required_cmd"
fi

# Main script logic
main() {
    info "Starting script"
    # ... your code here ...
    info "Script completed successfully"
}

main "$@"
```

