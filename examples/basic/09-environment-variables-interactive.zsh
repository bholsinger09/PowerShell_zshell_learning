#!/bin/zsh

# Interactive Environment Variables Tutorial
# Learn by doing: setting and using environment variables
# Usage: ./09-environment-variables-interactive.zsh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Function to pause
wait_for_user() {
    echo ""
    echo -e "${YELLOW}Press ENTER to continue...${NC}"
    read -r
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

# Function to show and execute
show_and_try() {
    local description="$1"
    local command="$2"
    
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}$description${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Command:${NC}"
    echo -e "${GREEN}$command${NC}"
    echo ""
    echo -e "${YELLOW}Press ENTER to see the result...${NC}"
    read -r
    echo ""
    echo -e "${CYAN}Output:${NC}"
    eval "$command"
}

# Main tutorial
clear

echo -e "${GREEN}"
cat << 'EOF'
╔════════════════════════════════════════════════════════╗
║                                                        ║
║   INTERACTIVE ENVIRONMENT VARIABLES TUTORIAL           ║
║   Pass data to programs and processes                  ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "${YELLOW}Environment variables are POWERFUL for DevOps!${NC}"
echo "They let you configure scripts without editing code."
echo "Same script, different behavior, just change variables."
echo ""
wait_for_user

# ============ EXAMPLE 1 ============
explain "EXAMPLE 1: What are environment variables?" \
"Environment variables are KEY=VALUE pairs available to programs.
They're different from shell variables:

  SHELL VARIABLE:      Only in current shell
  ENVIRONMENT VAR:     Passed to all child programs

Think of them as: Labels attached to your shell that programs can read.

Let's see the difference:"

show_and_try "Create a shell variable (stays here):" \
"MY_SHELL_VAR='only in this shell'; echo \$MY_SHELL_VAR"

wait_for_user

show_and_try "Create an environment variable (passes to programs):" \
"export MY_ENV_VAR='available to programs'; echo \$MY_ENV_VAR"

wait_for_user

explain "KEY DIFFERENCE:" \
"Shell variable: MY_VAR='hello'
  Only exists in THIS shell
  Child processes DON'T see it

Environment variable: export MY_VAR='hello'
  Exists in THIS shell
  ALL child processes SEE it
  This is what we want for configuration!"

wait_for_user

# ============ EXAMPLE 2 ============
explain "EXAMPLE 2: See all environment variables" \
"The 'env' command shows every environment variable.
They're set automatically by the system + anything you add."

show_and_try "List first 10 environment variables:" \
"env | head -10"

wait_for_user

explain "WHAT YOU SAW:" \
"Each line is a variable in NAME=value format
The system automatically sets many of them:
  PATH = where to find programs
  HOME = your home directory
  USER = your username
  SHELL = your shell program
  PWD = current working directory"

wait_for_user

# ============ EXAMPLE 3 ============
explain "EXAMPLE 3: Access specific environment variables" \
"Use \$VARIABLE_NAME to read an environment variable.
These are set by the system automatically."

show_and_try "Get your home directory:" \
"echo 'Your home: '\$HOME"

wait_for_user

show_and_try "Get your username:" \
"echo 'Logged in as: '\$USER"

wait_for_user

show_and_try "Get current shell:" \
"echo 'Using shell: '\$SHELL"

wait_for_user

show_and_try "Get current directory:" \
"echo 'Current location: '\$PWD"

wait_for_user

explain "THESE ARE BUILT-IN:" \
"\$HOME, \$USER, \$SHELL, \$PWD are set automatically by the system.
You can READ them but don't usually CHANGE them.
Let's create our OWN environment variables!"

wait_for_user

# ============ EXAMPLE 4 ============
explain "EXAMPLE 4: Create your own environment variable" \
"Use 'export VARIABLE=value' to create an environment variable.
It's now available to all child processes."

show_and_try "Create an environment variable:" \
"export GREETING='Welcome to environment variables!'; echo \$GREETING"

wait_for_user

explain "WHAT HAPPENED:" \
"export GREETING='Welcome to environment variables!'
  Creates a variable named GREETING
  Sets its value to the text
  Makes it available to child processes

Then we used: echo \$GREETING
  Reads the value
  Prints it"

wait_for_user

# ============ EXAMPLE 5 ============
explain "EXAMPLE 5: Set variable just for ONE command" \
"You can set a variable for just ONE command:
  VARIABLE=value command

After the command finishes, the variable disappears.
This is useful for temporary settings!"

show_and_try "Set variable for ONE command only:" \
"TEMP_VAR='just for this command' bash -c 'echo Temp value: \$TEMP_VAR'"

wait_for_user

show_and_try "After the command, variable is gone:" \
"echo 'Now check: '\$TEMP_VAR"

wait_for_user

explain "ONE-TIME VS PERMANENT:" \
"One-time: VARIABLE=value command
  Variable only exists for that command
  Useful for testing or temporary settings

Permanent: export VARIABLE=value
  Variable exists for entire shell session
  All commands can use it
  Goes away when you close terminal"

wait_for_user

# ============ EXAMPLE 6 ============
explain "EXAMPLE 6: Use environment variable in script" \
"Scripts can READ environment variables.
This is how you configure scripts without editing them!"

show_and_try "Create a script that reads an environment variable:" \
"cat > /tmp/demo_script.sh << 'SCRIPT'\n#!/bin/bash\necho \"Config says: MESSAGE=\$MESSAGE\"\necho \"Current user: \$USER\"\nSCRIPT\nchmod +x /tmp/demo_script.sh\necho 'Script created'"

wait_for_user

show_and_try "Run script WITHOUT setting variable:" \
"/tmp/demo_script.sh"

wait_for_user

show_and_try "Run script WITH environment variable:" \
"export MESSAGE='Hello from environment!'; /tmp/demo_script.sh"

wait_for_user

explain "SCRIPT BEHAVIOR CHANGED!" \
"Same script, different output!
When MESSAGE was set, script used it.
When MESSAGE wasn't set, it was empty.

This is how DevOps configuration works:
  Script stays the same
  Environment variables control behavior
  No need to edit files for different environments!"

wait_for_user

# ============ EXAMPLE 7 ============
explain "EXAMPLE 7: Common DevOps environment variables" \
"Real DevOps uses specific environment variables for configuration.
Let's see what they control:"

show_and_try "Set DevOps configuration variables:" \
"export APP_ENV='production'\nexport DATABASE_URL='postgres://db.example.com'\nexport API_KEY='secret123abc'\nexport PORT='3000'\nexport DEBUG='false'\necho 'Configuration set:'\necho \"  APP_ENV=\$APP_ENV\"\necho \"  DATABASE_URL=\$DATABASE_URL\"\necho \"  API_KEY=\$API_KEY\"\necho \"  PORT=\$PORT\"\necho \"  DEBUG=\$DEBUG\""

wait_for_user

explain "REAL WORLD USAGE:" \
"APP_ENV tells app if it's in dev/staging/production
DATABASE_URL tells where to connect for data
API_KEY is authentication token (secret!)
PORT tells app which network port to use
DEBUG controls how much logging happens

All without editing the actual program!
Change variables → change behavior
Same for dev, staging, production!"

wait_for_user

# ============ EXAMPLE 8 ============
explain "EXAMPLE 8: Check if variable exists and use fallback" \
"Scripts often check if a variable is set.
If not set, use a default value.
Syntax: \${VARIABLE:-default_value}"

show_and_try "Use variable with fallback:" \
"echo \"Config file location: \${CONFIG_FILE:-/etc/app/config.conf}\"\nexport CONFIG_FILE='/custom/config.conf'\necho \"Config file location: \${CONFIG_FILE:-/etc/app/config.conf}\""

wait_for_user

explain "FALLBACK PATTERN:" \
"\${VARIABLE:-default} means:
  If VARIABLE is set, use it
  If VARIABLE is NOT set, use default

This is safe! Always provides a value.
Common in production scripts for reliability."

wait_for_user

# ============ EXAMPLE 9 ============
explain "EXAMPLE 9: Load environment from a file" \
"DevOps teams often keep variables in .env files.
Then load them with 'source' command."

show_and_try "Create an environment file:" \
"cat > /tmp/.env << 'ENV'\nAPP_NAME='MyApplication'\nAPP_VERSION='2.0.0'\nLOG_LEVEL='info'\nMAX_CONNECTIONS='100'\nENV\necho '.env file created:'\ncat /tmp/.env"

wait_for_user

show_and_try "Load variables from file:" \
"source /tmp/.env\necho 'Variables loaded:'\necho \"  APP_NAME=\$APP_NAME\"\necho \"  LOG_LEVEL=\$LOG_LEVEL\"\necho \"  MAX_CONNECTIONS=\$MAX_CONNECTIONS\""

wait_for_user

explain "FILE-BASED CONFIGURATION:" \
"Create .env file with all variables
Use: source /path/to/.env
All variables now available in shell
Perfect for:
  Different environments (dev.env, prod.env)
  Secrets management
  Team configuration
  Easy version control (git ignore .env)"

wait_for_user

# ============ EXAMPLE 10 ============
explain "EXAMPLE 10: Modify PATH to add programs" \
"PATH tells shell where to find programs.
Add directories to PATH and programs there become available."

show_and_try "Create custom program directory:" \
"mkdir -p /tmp/my_programs\necho '#!/bin/bash\necho Hello from my program!' > /tmp/my_programs/greet\nchmod +x /tmp/my_programs/greet\necho 'Program created in /tmp/my_programs'"

wait_for_user

show_and_try "Add to PATH and run program:" \
"export PATH=\"/tmp/my_programs:\$PATH\"\ngreet"

wait_for_user

explain "PATH MANIPULATION:" \
"export PATH=\"/new/path:\$PATH\"
  Adds new path to beginning
  Shell searches it FIRST
  Your programs run immediately

Common uses:
  Add local bin directories
  Override system programs
  Include development tools
  DevOps pipeline management"

wait_for_user

# ============ EXAMPLE 11 ============
explain "EXAMPLE 11: Environment determines program behavior" \
"Programs check environment variables and behave accordingly.
Same program, different behavior based on environment!"

show_and_try "Create behavior-changing script:" \
"cat > /tmp/app.sh << 'APP'\n#!/bin/bash\nif [ \"\$ENVIRONMENT\" = \"production\" ]; then\n  echo 'PRODUCTION MODE:'\n  echo '  ✓ Backups enabled'\n  echo '  ✓ Monitoring active'\n  echo '  ✗ Debug disabled'\nelif [ \"\$ENVIRONMENT\" = \"staging\" ]; then\n  echo 'STAGING MODE:'\n  echo '  ✓ Testing features'\n  echo '  ✓ Debug enabled'\nelse\n  echo 'DEVELOPMENT MODE:'\n  echo '  ✓ Fast reload'\n  echo '  ✓ Full debug'\nfi\nAPP\nchmod +x /tmp/app.sh\necho 'Script created'"

wait_for_user

show_and_try "Run in development (default):" \
"/tmp/app.sh"

wait_for_user

show_and_try "Run in staging:" \
"ENVIRONMENT=staging /tmp/app.sh"

wait_for_user

show_and_try "Run in production:" \
"ENVIRONMENT=production /tmp/app.sh"

wait_for_user

explain "SAME SCRIPT, THREE BEHAVIORS!" \
"This is powerful DevOps pattern:
  One script for all environments
  Just change ENVIRONMENT variable
  No code changes needed
  Deploy identical code everywhere
  Easy rollback and testing"

wait_for_user

# ============ EXAMPLE 12 ============
explain "EXAMPLE 12: Real DevOps pattern - deployment script" \
"Combine everything into a realistic deployment script.
This is what teams use daily!"

show_and_try "Create realistic deployment script:" \
"cat > /tmp/deploy.sh << 'DEPLOY'\n#!/bin/bash\n# Deployment script using environment variables\n\n# Read from environment (or use defaults)\nAPP_NAME=\${APP_NAME:-'MyApp'}\nAPP_VERSION=\${APP_VERSION:-'1.0.0'}\nDEPLOY_ENV=\${DEPLOY_ENV:-'staging'}\nDEPLOY_USER=\${DEPLOY_USER:-'nobody'}\n\necho \"═══════════════════════════════════════\"\necho \"Deploying \$APP_NAME v\$APP_VERSION\"\necho \"Environment: \$DEPLOY_ENV\"\necho \"Deployed by: \$DEPLOY_USER\"\necho \"═══════════════════════════════════════\"\n\nif [ \"\$DEPLOY_ENV\" = \"production\" ]; then\n  echo \"🔒 PRODUCTION DEPLOYMENT:\"\n  echo \"  [1] Creating backup...\"\n  echo \"  [2] Verifying checksums...\"\n  echo \"  [3] Draining connections...\"\n  echo \"  [4] Deploying new version...\"\n  echo \"  [5] Health check...\"\n  echo \"  [6] Monitoring alert...\"\nelif [ \"\$DEPLOY_ENV\" = \"staging\" ]; then\n  echo \"🟡 STAGING DEPLOYMENT:\"\n  echo \"  [1] Quick backup...\"\n  echo \"  [2] Deploying version...\"\n  echo \"  [3] Running tests...\"\nelse\n  echo \"🔵 DEVELOPMENT DEPLOYMENT:\"\n  echo \"  [1] Direct deploy (no backup)\"\n  echo \"  [2] Skipping tests\"\nfi\n\necho \"\"\necho \"✅ Deployment complete!\"\nDEPLOY\nchmod +x /tmp/deploy.sh\necho 'Deployment script created'"

wait_for_user

show_and_try "Run with default (development):" \
"/tmp/deploy.sh"

wait_for_user

show_and_try "Run with production settings:" \
"APP_NAME='PaymentApp' APP_VERSION='2.5.1' DEPLOY_ENV='production' DEPLOY_USER='devops-team' /tmp/deploy.sh"

wait_for_user

explain "THIS IS PRODUCTION-GRADE!" \
"Notice how the SAME script:
  Takes different actions based on DEPLOY_ENV
  Shows appropriate safeguards for production
  Can be run with different versions
  Tracks who deployed it

This pattern scales to enterprise systems!
Configuration → Behavior
No code changes needed
Reliable, repeatable, auditable"

wait_for_user

# ============ PRACTICE TIME ============
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} YOUR TURN: TRY THESE CHALLENGES"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

echo "Challenge 1: Create an environment variable and use it"
echo "  - Set: export MY_SKILL='zshell programming'"
echo "  - Then: echo \"I'm learning: \$MY_SKILL\""
echo ""
echo -e "${YELLOW}Type your command(s):${NC}"
read -r challenge1a
read -r challenge1b 2>/dev/null
eval "$challenge1a" 2>/dev/null && eval "$challenge1b" 2>/dev/null || echo "Try: export MY_SKILL='zshell'; echo \$MY_SKILL"

echo ""
echo ""
echo "Challenge 2: Run a command with temporary variables"
echo "  - Set: USER_ID='12345' and TASK='backup'"
echo "  - Echo them both in one bash command"
echo ""
echo -e "${YELLOW}Type your command:${NC}"
read -r challenge2
eval "$challenge2" 2>/dev/null || echo "Try: USER_ID='12345' TASK='backup' bash -c 'echo User: \$USER_ID, Task: \$TASK'"

echo ""
echo ""
echo "Challenge 3: Check if variable exists with fallback"
echo "  - Use: \${UNDEFINED_VAR:-'default value'}"
echo "  - Create a real variable and echo with fallback too"
echo ""
echo -e "${YELLOW}Type your command(s):${NC}"
read -r challenge3a
read -r challenge3b 2>/dev/null
eval "$challenge3a" 2>/dev/null && eval "$challenge3b" 2>/dev/null || echo "Try: echo \"Value: \${UNKNOWN:-default}\""

# ============ SUMMARY ============
echo ""
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} SUMMARY: Environment Variables"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

cat << 'EOF'
KEY CONCEPTS LEARNED:

1. Shell Variables vs Environment Variables
   SHELL_VAR="hello"           (only in current shell)
   export ENV_VAR="hello"      (passes to child processes)

2. Creating Environment Variables
   export VARIABLE="value"     Create and export
   VARIABLE="value" command    Just for this command

3. Reading Environment Variables
   echo $VARIABLE              Access the value
   env | grep VARIABLE         Find specific variable
   printenv                    List all variables

4. Common System Variables
   $HOME        Your home directory
   $USER        Your username
   $PWD         Current directory
   $SHELL       Your shell program
   $PATH        Where programs are located

5. DevOps Configuration Pattern
   • Set environment variables
   • Scripts read them
   • No code changes needed
   • Different behavior per environment
   • Production-safe pattern

6. Real World Variables
   APP_ENV             development/staging/production
   DATABASE_URL        Database connection string
   API_KEY             Authentication token
   PORT                Network port
   DEBUG               Enable/disable debug mode
   LOG_LEVEL           error/warn/info/debug

7. File-Based Configuration
   source /path/to/.env file   Load multiple variables
   Perfect for team workflows

8. Conditional Defaults
   ${VARIABLE:-default}        Use value or default
   ${VARIABLE:-alternative}    Safe fallback pattern

COMMANDS YOU LEARNED:
   export VARIABLE="value"          Create environment variable
   echo $VARIABLE                   Read environment variable
   env                              List all environment variables
   printenv | grep VARIABLE         Find specific variable
   VARIABLE="value" command         Set for one command
   source /path/to/file             Load variables from file

PRODUCTION PATTERN:
   ✓ Store configuration in environment
   ✓ Scripts read environment variables
   ✓ No hardcoded values in code
   ✓ Easy to change per environment
   ✓ Secure (secrets not in code)
   ✓ Auditable (track changes)
   ✓ Scalable (works at enterprise scale)

REMEMBER:
   Environment variables are your configuration system
   Use them INSTEAD of hardcoding values
   Same script → different behavior per environment
   This is professional DevOps practice!
EOF

echo ""
echo -e "${YELLOW}Congratulations! You've mastered environment variables! 🎉${NC}"
echo ""
echo -e "${GREEN}Next: Use these in real deployment scripts!${NC}"
echo ""
