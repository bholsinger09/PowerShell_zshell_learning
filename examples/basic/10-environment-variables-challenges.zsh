#!/bin/zsh

# Environment Variables Practice Challenges
# Apply what you learned with real-world scenarios
# Usage: ./10-environment-variables-challenges.zsh [challenge_number]

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Parse arguments
CHALLENGE=${1:-all}

show_challenge() {
    local num=$1
    local title=$2
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║ CHALLENGE $num: $title${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_solution() {
    echo ""
    echo -e "${BLUE}✅ SOLUTION:${NC}"
    echo ""
}

# ============ CHALLENGE 1.1 ============
if [[ "$CHALLENGE" == "1.1" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "1.1" "Create and use environment variables"

cat << 'EOF'
OBJECTIVE:
  Create environment variables and access them from a script

TASK:
  1. Create an environment variable: APP_NAME="DevOps Automation"
  2. Create another: APP_VERSION="2.0.0"
  3. Create a script that reads both variables
  4. Run the script and verify it shows both values

EXPECTED OUTPUT:
  App Name: DevOps Automation
  App Version: 2.0.0

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
export APP_NAME="DevOps Automation"
export APP_VERSION="2.0.0"

cat > /tmp/app_info.sh << 'SCRIPT'
#!/bin/bash
echo "App Name: $APP_NAME"
echo "App Version: $APP_VERSION"
SCRIPT

chmod +x /tmp/app_info.sh
/tmp/app_info.sh
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • Using export to create environment variables"
echo "  • Reading variables in scripts with \$VARIABLE"
echo "  • Variables persist across child processes"
echo "  • This is how you configure applications"
fi

# ============ CHALLENGE 1.2 ============
if [[ "$CHALLENGE" == "1.2" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "1.2" "One-time variable for single command"

cat << 'EOF'
OBJECTIVE:
  Set an environment variable for just ONE command execution

TASK:
  1. Without exporting globally, set: LOG_LEVEL="DEBUG"
  2. Run a command that reads LOG_LEVEL
  3. Verify the command sees it
  4. Verify the variable doesn't exist after

PATTERN:
  VARIABLE="value" command

EXPECTED OUTPUT:
  Log level is: DEBUG
  Then: (empty when checking variable)

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
# Set variable for just one command
LOG_LEVEL="DEBUG" bash -c 'echo "Log level is: $LOG_LEVEL"'

# Verify it's gone
echo "Now check: $LOG_LEVEL"
# (empty output)
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • Temporary environment variables"
echo "  • Syntax: VARIABLE=value command"
echo "  • Useful for testing or one-off changes"
echo "  • Variable only exists for that command"
fi

# ============ CHALLENGE 2.1 ============
if [[ "$CHALLENGE" == "2.1" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "2.1" "Script behavior changes with environment"

cat << 'EOF'
OBJECTIVE:
  Same script behaves differently based on environment variable

TASK:
  1. Create a script that checks ENVIRONMENT variable
  2. If ENVIRONMENT="production" → show production-safe output
  3. If ENVIRONMENT="development" → show dev output
  4. Run it with both settings

EXPECTED OUTPUT (dev):
  Running in DEVELOPMENT
  Debug: ON, Backups: OFF

EXPECTED OUTPUT (prod):
  Running in PRODUCTION
  Debug: OFF, Backups: ON

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
cat > /tmp/env_aware.sh << 'SCRIPT'
#!/bin/bash
if [ "$ENVIRONMENT" = "production" ]; then
    echo "Running in PRODUCTION"
    echo "Debug: OFF, Backups: ON"
elif [ "$ENVIRONMENT" = "development" ]; then
    echo "Running in DEVELOPMENT"
    echo "Debug: ON, Backups: OFF"
else
    echo "Running in UNKNOWN mode"
fi
SCRIPT

chmod +x /tmp/env_aware.sh

# Run in development
echo "=== Run 1: Development ==="
ENVIRONMENT="development" /tmp/env_aware.sh

# Run in production
echo ""
echo "=== Run 2: Production ==="
ENVIRONMENT="production" /tmp/env_aware.sh
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • Scripts check environment variables"
echo "  • Same code, different behavior"
echo "  • No need to edit files for different environments"
echo "  • Professional DevOps pattern"
fi

# ============ CHALLENGE 2.2 ============
if [[ "$CHALLENGE" == "2.2" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "2.2" "Use environment variables with fallbacks"

cat << 'EOF'
OBJECTIVE:
  Use variables with default values (fallbacks)

TASK:
  1. Create a script that reads: DB_HOST, DB_PORT, DB_NAME
  2. Use defaults if not set:
     DB_HOST defaults to "localhost"
     DB_PORT defaults to "5432"
     DB_NAME defaults to "myapp"
  3. Run WITHOUT variables (should use defaults)
  4. Run WITH variables (should use your values)

PATTERN:
  ${VARIABLE:-default_value}

EXPECTED OUTPUT (no vars):
  Host: localhost
  Port: 5432
  Name: myapp

EXPECTED OUTPUT (with vars):
  Host: prod.db.com
  Port: 3306
  Name: production

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
cat > /tmp/db_config.sh << 'SCRIPT'
#!/bin/bash
echo "Database Configuration:"
echo "Host: ${DB_HOST:-localhost}"
echo "Port: ${DB_PORT:-5432}"
echo "Name: ${DB_NAME:-myapp}"
SCRIPT

chmod +x /tmp/db_config.sh

# Run without variables
echo "=== Default Configuration ==="
/tmp/db_config.sh

# Run with variables
echo ""
echo "=== Custom Configuration ==="
DB_HOST="prod.db.com" DB_PORT="3306" DB_NAME="production" /tmp/db_config.sh
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • Fallback pattern: \${VAR:-default}"
echo "  • Scripts always have a value"
echo "  • Flexible configuration"
echo "  • Safe and reliable code"
fi

# ============ CHALLENGE 3.1 ============
if [[ "$CHALLENGE" == "3.1" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "3.1" "Load configuration from file"

cat << 'EOF'
OBJECTIVE:
  Load multiple environment variables from a .env file

TASK:
  1. Create a .env file with variables:
     SERVER_NAME="api.example.com"
     SERVER_PORT="8080"
     ADMIN_EMAIL="admin@example.com"
  2. Source the file to load variables
  3. Verify all variables are available
  4. Use them in a greeting message

EXPECTED OUTPUT:
  Configuration loaded!
  Server Name: api.example.com
  Server Port: 8080
  Admin Email: admin@example.com

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
# Create .env file
cat > /tmp/server.env << 'ENV'
SERVER_NAME="api.example.com"
SERVER_PORT="8080"
ADMIN_EMAIL="admin@example.com"
ENV

# Source it to load variables
source /tmp/server.env

# Verify and use them
echo "Configuration loaded!"
echo "Server Name: $SERVER_NAME"
echo "Server Port: $SERVER_PORT"
echo "Admin Email: $ADMIN_EMAIL"
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • File-based configuration with .env"
echo "  • Using 'source' to load variables"
echo "  • Common in DevOps and teams"
echo "  • Easy to manage different environments"
fi

# ============ CHALLENGE 3.2 ============
if [[ "$CHALLENGE" == "3.2" ]] || [[ "$CHALLENGE" == "all" ]]; then
show_challenge "3.2" "Real DevOps: Deployment script with environment vars"

cat << 'EOF'
OBJECTIVE:
  Build a realistic deployment script that uses environment variables

TASK:
  1. Create a deployment script that reads:
     - APP_NAME (required)
     - APP_VERSION (required)
     - DEPLOY_ENV (production/staging/development)
     - DEPLOY_USER (who is deploying)
  2. Show different messages based on DEPLOY_ENV
  3. Production: Show security checks
     Staging: Show quick checks
     Development: Minimal checks
  4. Run with different environment values

EXPECTED OUTPUT (production):
  Deploying PaymentSystem v3.2.1
  Environment: production
  Deployed by: devops-team
  [Production Security Checks]

EXPECTED OUTPUT (development):
  Deploying PaymentSystem v3.2.1
  Environment: development
  Deployed by: developer1
  [Quick Deploy]

TRY IT YOURSELF FIRST!
Press ENTER to see the solution...
EOF

read -r

show_solution

cat << 'SOLUTION'
cat > /tmp/deploy_real.sh << 'DEPLOY'
#!/bin/bash

# Read from environment
APP_NAME=${APP_NAME:-"MyApp"}
APP_VERSION=${APP_VERSION:-"1.0.0"}
DEPLOY_ENV=${DEPLOY_ENV:-"development"}
DEPLOY_USER=${DEPLOY_USER:-"unknown"}

echo "═════════════════════════════════════════"
echo "Deploying $APP_NAME v$APP_VERSION"
echo "Environment: $DEPLOY_ENV"
echo "Deployed by: $DEPLOY_USER"
echo "═════════════════════════════════════════"
echo ""

if [ "$DEPLOY_ENV" = "production" ]; then
    echo "🔒 PRODUCTION DEPLOYMENT:"
    echo "  ✓ Verify SSL certificates"
    echo "  ✓ Run database backups"
    echo "  ✓ Check disk space"
    echo "  ✓ Verify health checks"
    echo "  ✓ Alert monitoring team"
elif [ "$DEPLOY_ENV" = "staging" ]; then
    echo "🟡 STAGING DEPLOYMENT:"
    echo "  ✓ Run integration tests"
    echo "  ✓ Quick database backup"
    echo "  ✓ Deploy new version"
else
    echo "🔵 DEVELOPMENT DEPLOYMENT:"
    echo "  ✓ Fast redeploy"
    echo "  ✓ No backups needed"
fi

echo ""
echo "✅ Deployment script complete!"
DEPLOY

chmod +x /tmp/deploy_real.sh

# Run 1: Production
echo "=== PRODUCTION DEPLOYMENT ==="
APP_NAME="PaymentSystem" APP_VERSION="3.2.1" DEPLOY_ENV="production" DEPLOY_USER="devops-team" /tmp/deploy_real.sh

echo ""
echo ""

# Run 2: Development
echo "=== DEVELOPMENT DEPLOYMENT ==="
APP_NAME="PaymentSystem" APP_VERSION="3.2.1" DEPLOY_ENV="development" DEPLOY_USER="developer1" /tmp/deploy_real.sh
SOLUTION

echo ""
echo -e "${YELLOW}What this teaches:${NC}"
echo "  • Production-grade deployment patterns"
echo "  • Environment-aware behavior"
echo "  • Same script, different safety levels"
echo "  • How real DevOps automation works"
echo "  • Configuration through environment variables"
fi

# ============ SUMMARY ============
if [[ "$CHALLENGE" == "all" ]]; then
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║ ALL CHALLENGES COMPLETE! 🎉${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "You've learned:"
echo "  ✅ Creating environment variables"
echo "  ✅ Using variables in scripts"
echo "  ✅ Environment-aware behavior"
echo "  ✅ Fallback patterns"
echo "  ✅ File-based configuration"
echo "  ✅ Real DevOps deployment patterns"
echo ""
fi

echo ""
