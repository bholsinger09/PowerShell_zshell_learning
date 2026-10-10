# Quick Start Guide

## Get Started in 5 Minutes

### 1. Test Your Setup (2 min)

```zsh
cd ~/Documents/Zshell_Project

# Run the hello-world example
./examples/basic/01-hello-world.zsh

# Run the variables example
./examples/basic/02-variables-and-types.zsh
```

### 2. Run Your First Monitoring Script (1 min)

```zsh
# Check system health
./scripts/monitoring/system-health-check.zsh

# With verbose output
./scripts/monitoring/system-health-check.zsh --verbose

# With logging enabled
./scripts/monitoring/system-health-check.zsh --log --verbose

# Check log file
cat ~/.logs/zshell-automation/system-health-check.log
```

### 3. Manage Applications (1 min)

```zsh
# Show available application sets
./scripts/applications/manage-applications.zsh show-sets

# List currently running apps
./scripts/applications/manage-applications.zsh list-running

# Open Slack
./scripts/applications/manage-applications.zsh open Slack

# Close Slack
./scripts/applications/manage-applications.zsh close Slack

# Launch development apps
./scripts/applications/manage-applications.zsh launch-set dev
```

### 4. Create Your First Custom Script (1 min)

```zsh
cat > ~/Documents/Zshell_Project/scripts/utilities/my-first-script.zsh << 'EOF'
#!/bin/zsh
# My first automation script

# Source common functions
source "${0:a:h}/../lib/common-functions.sh"

main() {
    init_logging
    
    log_info "Starting my automation..."
    
    # Your code here
    echo "Hello from my custom script!"
    
    log_success "Done!"
}

main "$@"
EOF

chmod +x ~/Documents/Zshell_Project/scripts/utilities/my-first-script.zsh
./scripts/utilities/my-first-script.zsh
```

## Common Tasks

### Monitor System Performance Hourly

1. Open `docs/macos-automation.md` → "Creating a LaunchAgent"
2. Copy the example .plist file
3. Update paths to point to your script
4. Load with `launchctl load ~/Library/LaunchAgents/com.example.health-check.plist`

### Add Custom Application Set

Edit `scripts/applications/manage-applications.zsh`:

```zsh
# Find this section (around line 14):
declare -A APP_SETS
APP_SETS[dev]="VS Code Terminal Safari"
APP_SETS[work]="Slack Mail Calendar"
APP_SETS[media]="Spotify Music Photos"

# Add your own:
APP_SETS[my-set]="Safari "Mail" "Calendar"

# Then use:
./scripts/applications/manage-applications.zsh launch-set my-set
```

### Schedule a Startup Task

1. Create your script in `scripts/startup/`
2. Create a .plist file in `config/startup-launchd/`
3. Use `StartCalendarInterval` to run at specific times
4. Load with `launchctl load`

### Add Error Handling to Your Script

```zsh
#!/bin/zsh
set -euo pipefail
trap 'echo "Error on line $LINENO"; exit 1' ERR

# Source common functions for better error handling
source "${0:a:h}/../lib/common-functions.sh"

# Now use these functions:
require_command "curl"    # Exit if curl not found
command_exists "python3"  # Check if command exists
error_exit "Something went wrong"  # Exit with error
```

## Testing Your Scripts

### Lint Your Scripts

```zsh
# Install shellcheck (if not already installed)
brew install shellcheck

# Check your script for errors
shellcheck scripts/monitoring/system-health-check.zsh

# Check all scripts
find scripts -name "*.zsh" -exec shellcheck {} \;
```

### Debug Your Script

```zsh
# Run with debug output
zsh -x ./scripts/monitoring/system-health-check.zsh

# Or add inside script:
set -x  # Enable debug
# ... your code ...
set +x  # Disable debug
```

### Test with Clean Environment

```zsh
# Test like launchd would run it
env -i /bin/zsh ./scripts/monitoring/system-health-check.zsh
```

## File Locations Reference

```
~/Documents/Zshell_Project/
├── README.md                          # Overview
├── BEST_PRACTICES.md                  # Coding standards
├── docs/
│   ├── setup-guide.md                # Installation & setup
│   └── macos-automation.md           # macOS-specific tips
├── scripts/
│   ├── startup/                      # Startup scripts
│   ├── monitoring/                   # System monitoring
│   ├── applications/                 # App management
│   ├── utilities/                    # General utilities
│   └── lib/
│       └── common-functions.sh       # Shared functions
├── examples/
│   ├── basic/                        # Getting started
│   ├── intermediate/                 # More advanced
│   └── advanced/                     # Expert patterns
└── config/
    └── startup-launchd/             # LaunchD configs

Log files:
~/.logs/zshell-automation/            # All logs
```

## Essential Commands Quick Reference

```zsh
# Making scripts executable
chmod +x script.zsh

# Running scripts
./script.zsh
/bin/zsh ./script.zsh
source ./script.zsh

# Checking script syntax
zsh -n script.zsh

# Linting
shellcheck script.zsh

# Viewing logs
tail -f ~/.logs/zshell-automation/script.log

# Git workflow
git status
git add .
git commit -m "Your message"
git push origin master
```

## Common Errors and Fixes

| Error | Fix |
|-------|-----|
| `command not found: script.zsh` | Use `chmod +x script.zsh` to make it executable |
| `Permission denied` | Run `chmod +x script.zsh` or use `/bin/zsh script.zsh` |
| `script.zsh: command not found` | First line should be `#!/bin/zsh` or run `/bin/zsh script.zsh` |
| `No such file or directory` | Use full path: `/Users/benh/Documents/...` or `$(pwd)/script.zsh` |
| Variables not found in launchd | Use full paths and export variables in script |
| Scripts run manually but not in launchd | Test with `env -i /bin/zsh ./script.zsh` |

## Learning Path

### Week 1: Foundations
- [ ] Read `docs/setup-guide.md`
- [ ] Read `BEST_PRACTICES.md`
- [ ] Run `examples/basic/01-hello-world.zsh`
- [ ] Run `examples/basic/02-variables-and-types.zsh`
- [ ] Modify one example script

### Week 2: Practical Scripts
- [ ] Run `scripts/monitoring/system-health-check.zsh`
- [ ] Run `scripts/applications/manage-applications.zsh`
- [ ] Read `docs/macos-automation.md`
- [ ] Create your own utility script

### Week 3: Automation
- [ ] Create a startup script
- [ ] Set up a launchd agent
- [ ] Test scheduling
- [ ] Add logging

### Week 4+: Advanced
- [ ] Explore `examples/intermediate/`
- [ ] Build complex automation
- [ ] Contribute examples back to project

## Where to Get Help

1. **This Project**: Read the relevant `.md` files
2. **Apple Docs**: https://developer.apple.com/documentation/
3. **Zshell Manual**: http://zsh.sourceforge.net/Doc/
4. **Shell Scripting**: https://mywiki.wooledge.org/BashGuide
5. **Stack Overflow**: Search for `zsh` or `shell script`
6. **Local Tests**: Use `zsh -n` to check syntax

## Next Steps

1. ✅ Review this Quick Start
2. Read [docs/setup-guide.md](docs/setup-guide.md)
3. Run the example scripts
4. Create your first custom script
5. Schedule it with launchd
6. Share your scripts with the team!

---

**Questions?** Check the relevant documentation file or test your script with `zsh -n script.zsh` to find syntax errors.
