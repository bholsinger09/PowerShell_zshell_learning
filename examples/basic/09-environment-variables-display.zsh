#!/bin/zsh

# Environment Variables Tutorial - Display Version
# Learn how to pass data to processes
# Usage: ./09-environment-variables-display.zsh [example_number or 'all']

# Setup colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Parse arguments
EXAMPLE=${1:-1}

show_example() {
    local num=$1
    local title=$2
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║ EXAMPLE $num: $title${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ============ EXAMPLE 1 ============
if [[ "$EXAMPLE" == "1" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "1" "Shell variable vs Environment variable"

cat << 'EOF'
SHELL VARIABLE (local, doesn't pass to processes):
  MYVAR="hello"          (only in current shell)
  
ENVIRONMENT VARIABLE (passes to child processes):
  export MYVAR="hello"   (passes to all child processes)
  
DIFFERENCE:
  Shell variable = isolated to current shell
  Environment variable = inherited by all child processes

Let's see the difference:
EOF

echo ""
echo -e "${YELLOW}Shell variable (local):${NC}"
SHELL_VAR="hello from shell"
echo "Set: SHELL_VAR='hello from shell'"
echo "Access it: echo \$SHELL_VAR"
echo "Result: $(echo $SHELL_VAR)"

echo ""
echo -e "${YELLOW}Environment variable (inherited):${NC}"
export ENV_VAR="hello from environment"
echo "Set: export ENV_VAR='hello from environment'"
echo "Access it: echo \$ENV_VAR"
echo "Result: $(echo $ENV_VAR)"

echo ""
echo -e "${BLUE}KEY DIFFERENCE:${NC}"
echo "Shell variable only exists in THIS shell"
echo "Environment variable passes to ALL child processes"
fi

# ============ EXAMPLE 2 ============
if [[ "$EXAMPLE" == "2" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "2" "View all environment variables"

cat << 'EOF'
The 'env' command shows all environment variables.
Each variable is NAME=value format.
EOF

echo ""
echo -e "${YELLOW}All environment variables:${NC}"
env | head -10
echo "... (and many more)"

echo ""
echo -e "${BLUE}Common system environment variables:${NC}"
echo "  PATH         = Where shell looks for programs"
echo "  HOME         = Your home directory"
echo "  USER         = Your username"
echo "  SHELL        = Your shell program"
echo "  PWD          = Current working directory"
echo "  HOSTNAME     = Computer name"
echo "  LANG         = Language/locale setting"
fi

# ============ EXAMPLE 3 ============
if [[ "$EXAMPLE" == "3" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "3" "Access common environment variables"

cat << 'EOF'
You can read environment variables with $VARIABLE_NAME
EOF

echo ""
echo -e "${YELLOW}Common variables you can access:${NC}"
echo "HOME:     $HOME"
echo "USER:     $USER"
echo "PWD:      $PWD"
echo "SHELL:    $SHELL"
echo "HOSTNAME: $HOSTNAME"

echo ""
echo -e "${BLUE}These are set by the system automatically.${NC}"
fi

# ============ EXAMPLE 4 ============
if [[ "$EXAMPLE" == "4" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "4" "Set environment variable and use in script"

cat << 'EOF'
You can create your own environment variables and pass them to programs.
EOF

echo ""
echo -e "${YELLOW}Set and use environment variable:${NC}"
MY_MESSAGE="DevOps is fun!"
export MY_MESSAGE
echo "Set: export MY_MESSAGE=\"DevOps is fun!\""
echo ""
echo "Use in echo: echo \$MY_MESSAGE"
echo "Result: $(echo $MY_MESSAGE)"

echo ""
echo -e "${BLUE}This variable now exists for all child processes!${NC}"
fi

# ============ EXAMPLE 5 ============
if [[ "$EXAMPLE" == "5" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "5" "Pass environment variable to a single command"

cat << 'EOF'
You can set environment variables for just ONE command:
  VARIABLE=value command

This creates the variable only for that command, not globally.
EOF

echo ""
echo -e "${YELLOW}Set variable just for one command:${NC}"
echo "Command: MY_VAR='temporary' printenv | grep MY_VAR"
echo ""
echo -e "${YELLOW}Result:${NC}"
MY_VAR='temporary' printenv | grep MY_VAR

echo ""
echo -e "${YELLOW}After the command, the variable is gone:${NC}"
echo "Command: echo \$MY_VAR"
echo "Result: $(echo $MY_VAR)"
echo "(empty - variable only existed for that one command)"

echo ""
echo -e "${BLUE}This is useful for temporary settings!${NC}"
fi

# ============ EXAMPLE 6 ============
if [[ "$EXAMPLE" == "6" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "6" "Set environment variable for multiple commands"

cat << 'EOF'
Set a variable at the start of your shell session.
It will be available for all subsequent commands.
EOF

echo ""
echo -e "${YELLOW}Set a variable in current session:${NC}"
export API_KEY="abc123xyz789"
echo "Command: export API_KEY=\"abc123xyz789\""
echo ""
echo "Now use it in multiple commands:"
echo "  echo \$API_KEY"
echo "  Result: $(echo $API_KEY)"

echo ""
echo "In a script:"
echo "  curl -H \"Authorization: \$API_KEY\" https://api.example.com"
echo "  Would send: Authorization: abc123xyz789"

echo ""
echo -e "${BLUE}The variable persists until you close the shell.${NC}"
fi

# ============ EXAMPLE 7 ============
if [[ "$EXAMPLE" == "7" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "7" "Environment variables in shell scripts"

cat << 'EOF'
Scripts can access environment variables set in the shell.
This is how you configure scripts without editing them!
EOF

echo ""
echo -e "${YELLOW}Create test script that reads environment variable:${NC}"

cat > /tmp/test_env_script.sh << 'SCRIPT'
#!/bin/bash
if [ -z "$GREETING" ]; then
    echo "GREETING not set"
else
    echo "GREETING is: $GREETING"
fi
SCRIPT

chmod +x /tmp/test_env_script.sh

echo "Test 1: Run script WITHOUT setting variable:"
/tmp/test_env_script.sh

echo ""
echo "Test 2: Set variable and run script:"
export GREETING="Hello from environment!"
/tmp/test_env_script.sh

echo ""
echo -e "${BLUE}The script READ the environment variable!${NC}"
echo "This is how you configure scripts flexibly."
fi

# ============ EXAMPLE 8 ============
if [[ "$EXAMPLE" == "8" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "8" "Common DevOps environment variables"

cat << 'EOF'
DevOps uses environment variables for configuration:
  DATABASE_URL = Where to connect to database
  API_KEY = Authentication token
  DEBUG = Enable debug mode (true/false)
  PORT = Server port to listen on
  ENV = Environment (dev/staging/production)
  LOG_LEVEL = How much logging (error/warn/info/debug)
EOF

echo ""
echo -e "${YELLOW}Set common DevOps variables:${NC}"

export APP_ENV="development"
export DATABASE_URL="postgresql://localhost/mydb"
export API_KEY="secret123"
export PORT="3000"
export DEBUG="true"

echo "APP_ENV=$APP_ENV"
echo "DATABASE_URL=$DATABASE_URL"
echo "API_KEY=$API_KEY"
echo "PORT=$PORT"
echo "DEBUG=$DEBUG"

echo ""
echo -e "${BLUE}Real scripts check these and behave accordingly.${NC}"
fi

# ============ EXAMPLE 9 ============
if [[ "$EXAMPLE" == "9" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "9" "Modify PATH environment variable"

cat << 'EOF'
PATH tells the shell where to find executable programs.
When you type 'ls', the shell searches PATH directories.

You can add directories to PATH to make programs available.
EOF

echo ""
echo -e "${YELLOW}Current PATH:${NC}"
echo $PATH | tr ':' '\n' | head -5
echo "... (more directories)"

echo ""
echo -e "${YELLOW}Add a directory to PATH:${NC}"
mkdir -p /tmp/my_scripts
echo '#!/bin/zsh; echo "Hello from my script!"' > /tmp/my_scripts/hello
chmod +x /tmp/my_scripts/hello

export PATH="/tmp/my_scripts:$PATH"
echo "Added: /tmp/my_scripts"
echo ""
echo "Now you can run: hello"
echo "Result: $(hello)"

echo ""
echo -e "${BLUE}Programs in /tmp/my_scripts are now accessible!${NC}"
fi

# ============ EXAMPLE 10 ============
if [[ "$EXAMPLE" == "10" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "10" "Environment variables in conditionals"

cat << 'EOF'
Check environment variables to make decisions.
This is how you make scripts behave differently based on settings!
EOF

echo ""
echo -e "${YELLOW}Test environment-based behavior:${NC}"

export ENVIRONMENT="production"

if [ "$ENVIRONMENT" = "production" ]; then
    echo "Running in PRODUCTION mode"
    echo "  - Backups enabled"
    echo "  - Monitoring enabled"
    echo "  - Debug disabled"
elif [ "$ENVIRONMENT" = "staging" ]; then
    echo "Running in STAGING mode"
    echo "  - Testing new features"
else
    echo "Running in DEVELOPMENT mode"
    echo "  - Debug enabled"
fi

echo ""
echo -e "${BLUE}Same script behaves differently based on ENVIRONMENT!${NC}"
fi

# ============ EXAMPLE 11 ============
if [[ "$EXAMPLE" == "11" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "11" "Set environment variables from file"

cat << 'EOF'
Load environment variables from a file using 'source' or '.'
This is common in DevOps for configuration management.
EOF

echo ""
echo -e "${YELLOW}Create configuration file:${NC}"

cat > /tmp/.env_config << 'CONFIG'
# Application Configuration
APP_NAME="MyApp"
API_PORT="8080"
LOG_LEVEL="info"
DATABASE_HOST="db.example.com"
CONFIG

echo "File: /tmp/.env_config"
cat /tmp/.env_config

echo ""
echo -e "${YELLOW}Load variables from file:${NC}"
echo "Command: source /tmp/.env_config"
source /tmp/.env_config

echo "Now use them:"
echo "  APP_NAME = $APP_NAME"
echo "  API_PORT = $API_PORT"
echo "  LOG_LEVEL = $LOG_LEVEL"

echo ""
echo -e "${BLUE}This is how DevOps tools load configuration!${NC}"
fi

# ============ EXAMPLE 12 ============
if [[ "$EXAMPLE" == "12" ]] || [[ "$EXAMPLE" == "all" ]]; then
show_example "12" "Real DevOps pattern: Environment-based script"

cat << 'EOF'
Combine everything: environment variables control script behavior.
This is how production automation works!
EOF

echo ""
echo -e "${YELLOW}Create a deployment script pattern:${NC}"

cat > /tmp/deploy.sh << 'DEPLOY'
#!/bin/bash

# These come from environment variables
APP_ENV=${APP_ENV:-"development"}
APP_VERSION=${APP_VERSION:-"1.0.0"}
DEPLOY_DIR=${DEPLOY_DIR:-"/opt/app"}

echo "=== Deployment Script ==="
echo "Environment: $APP_ENV"
echo "Version: $APP_VERSION"
echo "Deploy to: $DEPLOY_DIR"

if [ "$APP_ENV" = "production" ]; then
    echo "Creating backups before deployment..."
    echo "Disabling connections..."
    echo "Running migrations..."
else
    echo "Running in test mode"
    echo "Skipping backups"
fi

echo "Deployment complete!"
DEPLOY

chmod +x /tmp/deploy.sh

echo ""
echo -e "${YELLOW}Run with default values:${NC}"
/tmp/deploy.sh

echo ""
echo -e "${YELLOW}Run with custom environment:${NC}"
APP_ENV="production" APP_VERSION="2.0.0" /tmp/deploy.sh

echo ""
echo -e "${BLUE}Same script, different behavior!${NC}"
echo "This is how DevOps automation works at scale."
fi

# ============ SUMMARY ============
if [[ "$EXAMPLE" == "summary" ]] || [[ "$EXAMPLE" == "all" ]]; then
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║ SUMMARY: Environment Variables${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

cat << 'EOF'
KEY CONCEPTS:

1. Shell Variable vs Environment Variable
   - Shell variable: local to current shell
   - Environment variable: inherited by child processes

2. Creating Environment Variables
   export VARIABLE="value"              Create and export
   VARIABLE="value" command             Just for this command

3. Common System Variables
   $PATH = Where programs are located
   $HOME = Your home directory
   $USER = Your username
   $PWD = Current directory
   $SHELL = Your shell program

4. Real-World DevOps Use Cases
   - Database credentials (DATABASE_URL)
   - API keys and tokens (API_KEY)
   - Configuration flags (DEBUG, LOG_LEVEL)
   - Environment type (APP_ENV=production)
   - Port numbers and paths (PORT, APP_DIR)

5. Loading from Files
   source /path/to/.env    Load multiple variables at once

6. Passing to Programs
   VARIABLE=value program   Set for single execution
   export VARIABLE="value"  Set for entire session

PATTERN IN PRODUCTION:
   1. Define environment variables
   2. Scripts read them (conditional behavior)
   3. No need to edit script files
   4. Easy to configure different environments
   5. Secure (credentials not in code)

COMMANDS USED:
   export VARIABLE="value"         Create environment variable
   echo $VARIABLE                  Read environment variable
   env                             List all environment variables
   printenv | grep VARIABLE        Find specific variable
   source /path/to/file            Load variables from file
   VARIABLE="value" command        Set for one command only
EOF
fi

echo ""
