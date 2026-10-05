# Running Zshell Scripts in iTerm2

Complete guide to executing all your DevOps automation scripts in iTerm2.

## Quick Start - 5 Minutes

### Step 1: Open iTerm2

1. Open **Spotlight Search** (Cmd + Space)
2. Type `iTerm` and press Enter
3. iTerm2 will launch with a new terminal window

### Step 2: Navigate to Your Project

```zsh
cd ~/Documents/Zshell_Project
```

Then verify the project is there:

```zsh
ls -la
```

You should see: `README.md`, `BEST_PRACTICES.md`, `QUICKSTART.md`, `scripts/`, `examples/`, `docs/`, etc.

### Step 3: Run Your First Script

Try the hello-world example:

```zsh
./examples/basic/01-hello-world.zsh
```

You should see:
```
Hello, Zshell Developer!
This is your first Zshell script!
```

**✅ You're now running Zshell scripts in iTerm2!**

---

## Running Each Script

### 1️⃣ Hello World Example

```zsh
cd ~/Documents/Zshell_Project
./examples/basic/01-hello-world.zsh
```

Expected output:
```
Hello, Zshell Developer!
This is your first Zshell script!
```

---

### 2️⃣ Variables & Types Example

```zsh
./examples/basic/02-variables-and-types.zsh
```

Expected output:
```
=== Zshell Variables and Types ===
String: Alice
Number: 42
Array first element: apple
All fruits: apple banana orange
Red color: #FF0000
Home directory: /Users/benh
Current user: benh
Shell: /bin/zsh
...
=== Done ===
```

---

### 3️⃣ System Health Check (Main Monitoring Script)

**Basic run:**
```zsh
./scripts/monitoring/system-health-check.zsh
```

**With verbose output (recommended for learning):**
```zsh
./scripts/monitoring/system-health-check.zsh --verbose
```

**With logging enabled:**
```zsh
./scripts/monitoring/system-health-check.zsh --log
```

**With both verbose and logging:**
```zsh
./scripts/monitoring/system-health-check.zsh --verbose --log
```

**View the log file:**
```zsh
cat ~/.logs/zshell-automation/system-health-check.log
```

**Follow log in real-time (keep it open):**
```zsh
tail -f ~/.logs/zshell-automation/system-health-check.log
```

---

### 4️⃣ Application Management Script

**Show available application sets:**
```zsh
./scripts/applications/manage-applications.zsh show-sets
```

Output:
```
ℹ️  Available application sets:

  dev: VS Code Terminal Safari
  work: Slack Mail Calendar
  media: Spotify Music Photos
```

**List all running applications:**
```zsh
./scripts/applications/manage-applications.zsh list-running
```

**List all installed applications:**
```zsh
./scripts/applications/manage-applications.zsh list-installed
```

**Show help:**
```zsh
./scripts/applications/manage-applications.zsh help
```

---

## iTerm2 Tips & Tricks

### Create a Bookmark for Easy Access

1. In iTerm2, go to **Profiles** → **Edit Profiles**
2. Click **General** tab
3. Find "Working Directory" section
4. Select "Directory" and enter: `/Users/benh/Documents/Zshell_Project`
5. Click **Save**
6. Next time you open this profile, it starts in your project folder

### Create Aliases for Quick Access

Add these to your `~/.zshrc` file to create shortcuts:

```zsh
# Open iTerm in project directory
alias zshell='cd ~/Documents/Zshell_Project'

# Quick run commands
alias zsh-hello='~/Documents/Zshell_Project/examples/basic/01-hello-world.zsh'
alias zsh-health='~/Documents/Zshell_Project/scripts/monitoring/system-health-check.zsh'
alias zsh-apps='~/Documents/Zshell_Project/scripts/applications/manage-applications.zsh'
alias zsh-vars='~/Documents/Zshell_Project/examples/basic/02-variables-and-types.zsh'
alias zsh-health-verbose='~/Documents/Zshell_Project/scripts/monitoring/system-health-check.zsh --verbose'
alias zsh-health-log='~/Documents/Zshell_Project/scripts/monitoring/system-health-check.zsh --log --verbose'
```

Then reload your shell:

```zsh
source ~/.zshrc
```

Now you can run:

```zsh
zsh-hello          # Run hello world
zsh-health         # Quick health check
zsh-health-verbose # Health check with details
zsh-health-log     # Health check with logging
zsh-apps show-sets # Show app sets
```

### iTerm2 Split Panes (Run Multiple Scripts)

**Open Split Pane Horizontally:**
```
Cmd + D
```

**Open Split Pane Vertically:**
```
Cmd + Shift + D
```

This lets you run one script in each pane simultaneously!

### Open Project Folder in Finder from iTerm2

```zsh
open .
```

Or:

```zsh
open ~/Documents/Zshell_Project
```

### Run Script and Keep Output Visible

By default, when a script finishes, you can still see the output. To pause:

```zsh
./scripts/monitoring/system-health-check.zsh --verbose
# Output stays on screen - just scroll up to see more
```

---

## Common iTerm2 Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd + N | New window |
| Cmd + T | New tab |
| Cmd + W | Close tab |
| Cmd + D | Split vertically |
| Cmd + Shift + D | Split horizontally |
| Cmd + ] | Next tab |
| Cmd + [ | Previous tab |
| Cmd + Opt + ← | Previous split pane |
| Cmd + Opt + → | Next split pane |
| Cmd + Shift + Enter | Full screen |
| Cmd + ; | Open command palette |

---

## Running Scripts Step-by-Step Examples

### Example 1: Full Health Check Session

```zsh
# Step 1: Navigate to project
cd ~/Documents/Zshell_Project

# Step 2: Run verbose health check to see what's happening
./scripts/monitoring/system-health-check.zsh --verbose

# Step 3: Run with logging
./scripts/monitoring/system-health-check.zsh --verbose --log

# Step 4: Check the log file
cat ~/.logs/zshell-automation/system-health-check.log

# Step 5: Watch log file in real-time
tail -f ~/.logs/zshell-automation/system-health-check.log
# Press Ctrl+C to stop watching
```

### Example 2: Learning Zshell

```zsh
# Step 1: Navigate
cd ~/Documents/Zshell_Project

# Step 2: Run hello world
./examples/basic/01-hello-world.zsh

# Step 3: Run variables example
./examples/basic/02-variables-and-types.zsh

# Step 4: Edit and modify a script
nano examples/basic/01-hello-world.zsh
# Make changes, press Ctrl+X to exit, Y to save

# Step 5: Run modified script
./examples/basic/01-hello-world.zsh
```

### Example 3: Application Management

```zsh
# Step 1: Navigate
cd ~/Documents/Zshell_Project

# Step 2: See available app sets
./scripts/applications/manage-applications.zsh show-sets

# Step 3: See running apps
./scripts/applications/manage-applications.zsh list-running

# Step 4: See installed apps
./scripts/applications/manage-applications.zsh list-installed

# Step 5: View help
./scripts/applications/manage-applications.zsh help
```

---

## Editing Scripts in iTerm2

### Using nano (easiest)

```zsh
nano scripts/utilities/my-script.zsh
```

Then:
- Edit your script
- Press `Ctrl + X` to exit
- Press `Y` to save
- Press `Enter` to confirm filename

### Using vim (more powerful)

```zsh
vim scripts/utilities/my-script.zsh
```

Then:
- Press `i` to insert
- Edit your script
- Press `Esc` then `:wq` to save and exit

### Using VS Code from iTerm2

```zsh
code scripts/utilities/my-script.zsh
```

This opens the file in VS Code instead of terminal editor.

---

## Checking Script Output

### View script output
```zsh
./scripts/monitoring/system-health-check.zsh
```

### Save output to a file
```zsh
./scripts/monitoring/system-health-check.zsh > output.txt
cat output.txt
```

### Redirect both stdout and stderr to a file
```zsh
./scripts/monitoring/system-health-check.zsh > output.txt 2>&1
cat output.txt
```

### Compare outputs (run twice and see differences)
```zsh
./scripts/monitoring/system-health-check.zsh > first-run.txt
./scripts/monitoring/system-health-check.zsh > second-run.txt
diff first-run.txt second-run.txt
```

---

## Debugging Scripts in iTerm2

### Run with debug output (shows every command)
```zsh
zsh -x ./scripts/monitoring/system-health-check.zsh
```

### Check script syntax without running it
```zsh
zsh -n ./scripts/monitoring/system-health-check.zsh
```

If no output, the script is syntactically correct!

### Find errors in your script
```zsh
shellcheck scripts/monitoring/system-health-check.zsh
```

(Install shellcheck first: `brew install shellcheck`)

### Run with error output only
```zsh
./scripts/monitoring/system-health-check.zsh 2>&1 | grep ERROR
```

---

## Creating a New Script in iTerm2

### Method 1: Using nano

```zsh
cd ~/Documents/Zshell_Project/scripts/utilities

# Create new script
nano my-awesome-script.zsh

# Add content (example):
#!/bin/zsh
echo "My awesome automation script!"

# Save: Ctrl+X, Y, Enter
# Make executable
chmod +x my-awesome-script.zsh

# Run it
./my-awesome-script.zsh
```

### Method 2: Using echo

```zsh
cd ~/Documents/Zshell_Project/scripts/utilities

cat > my-script.zsh << 'EOF'
#!/bin/zsh
# My first script
echo "This is my script!"
EOF

chmod +x my-script.zsh
./my-script.zsh
```

---

## Working with Git in iTerm2

### Check status
```zsh
cd ~/Documents/Zshell_Project
git status
```

### Commit changes
```zsh
git add scripts/utilities/my-script.zsh
git commit -m "Add my awesome script"
```

### Push to GitHub
```zsh
git push origin master
```

### View commit log
```zsh
git log --oneline
```

---

## Performance Monitoring While Scripts Run

### Open Activity Monitor
```zsh
open -a "Activity Monitor"
```

### Watch system activity in real-time
```zsh
# Watch CPU and memory
top

# Watch disk I/O
iostat 1 10

# Watch network
netstat -i 1
```

---

## Quick Reference: Essential Commands

```bash
# Navigate
cd ~/Documents/Zshell_Project

# List files
ls -la

# Run scripts
./examples/basic/01-hello-world.zsh
./scripts/monitoring/system-health-check.zsh --verbose
./scripts/applications/manage-applications.zsh show-sets

# View documentation
cat README.md
cat QUICKSTART.md
cat BEST_PRACTICES.md

# View logs
cat ~/.logs/zshell-automation/system-health-check.log
tail -f ~/.logs/zshell-automation/system-health-check.log

# Edit scripts
nano scripts/utilities/my-script.zsh

# Make executable
chmod +x scripts/utilities/my-script.zsh

# Check syntax
zsh -n scripts/utilities/my-script.zsh

# Git operations
git status
git add .
git commit -m "Your message"
git push origin master

# View project structure
tree -L 3
```

---

## iTerm2 Configuration Tips

### Recommended Settings

1. **Appearance**
   - Go to Preferences → Appearance
   - Tab Bar: Check "Show tab bar even when there's only one tab"
   - Window Style: Choose your preference
   - Theme: "Dark" for reduced eye strain

2. **Profiles**
   - Go to Preferences → Profiles
   - Select your profile
   - Under General → Working Directory: Set to `/Users/benh/Documents/Zshell_Project`
   - Under Colors: Adjust for your preference

3. **Advanced**
   - Go to Preferences → Advanced
   - Search "iterm2-get-cursor-style" and disable if needed

---

## Troubleshooting

### Script not found
```zsh
# Make sure you're in the right directory
pwd

# Navigate if needed
cd ~/Documents/Zshell_Project

# Check if script exists
ls -la scripts/monitoring/system-health-check.zsh
```

### Permission denied
```zsh
# Make script executable
chmod +x scripts/monitoring/system-health-check.zsh

# Try again
./scripts/monitoring/system-health-check.zsh
```

### Script runs but no output
```zsh
# Try with verbose
./scripts/monitoring/system-health-check.zsh --verbose

# Or check with debug
zsh -x ./scripts/monitoring/system-health-check.zsh
```

### Cannot find command
```zsh
# Make sure you're using full path
~/Documents/Zshell_Project/scripts/monitoring/system-health-check.zsh

# Or navigate first
cd ~/Documents/Zshell_Project
./scripts/monitoring/system-health-check.zsh
```

---

## Next Steps

1. **Open iTerm2** and navigate to the project
2. **Run the hello-world script** to verify everything works
3. **Run the system health check** to see real monitoring
4. **Create aliases** in your ~/.zshrc for quick access
5. **Set up a bookmark** in iTerm2 for the project folder
6. **Follow the QUICKSTART.md** for more learning

---

## Pro Tips

💡 **Tip 1:** Use Cmd+D to split your iTerm2 window vertically, so you can run different scripts side-by-side

💡 **Tip 2:** Add `zsh-health-verbose` to your login by putting it in ~/.zshrc to see system status every time you open a terminal

💡 **Tip 3:** Use `tail -f ~/.logs/zshell-automation/system-health-check.log` in one pane while running the script in another

💡 **Tip 4:** Create a shortcut with `alias` to avoid typing long paths every time

💡 **Tip 5:** Use `git status` to track which scripts you've modified and push them back to GitHub

---

You're all set to run these scripts in iTerm2! Start with the hello-world example and build from there. Happy scripting! 🚀
