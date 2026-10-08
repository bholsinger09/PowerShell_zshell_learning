# 🌍 Environment Variables Reference Guide

## What Are Environment Variables?

Environment variables are **named values** that programs can access. They're the primary way to **pass configuration to programs without editing code**.

### Key Difference: Shell vs Environment Variable

```bash
# SHELL VARIABLE (stays in this shell only)
MYVAR="hello"

# ENVIRONMENT VARIABLE (passes to all child processes)
export MYVAR="hello"
```

| Aspect | Shell Variable | Environment Variable |
|--------|---|---|
| Created | `VAR="value"` | `export VAR="value"` |
| Visible to | Current shell only | All child processes |
| Use case | Temporary values | Configuration |
| Persistence | Gone when shell closes | Gone when shell closes |
| Child processes | Cannot access | Can access ✓ |

---

## Creating Environment Variables

### 1. **Export for entire session**
```bash
export DATABASE_URL="postgresql://localhost/mydb"
export API_KEY="secret123"
export DEBUG="true"
```

Now all commands have access to these variables.

### 2. **Set for one command only**
```bash
VARIABLE="value" command
```

Example:
```bash
DATABASE_URL="test_db" ./deploy.sh    # Only deploy.sh sees DATABASE_URL
DEBUG="true" npm start                 # Only npm sees DEBUG
```

### 3. **Load from file**
```bash
source /path/to/.env
```

Create `.env` file:
```bash
# .env
APP_NAME="MyApp"
APP_VERSION="2.0.0"
LOG_LEVEL="info"
```

Then load:
```bash
source .env
echo $APP_NAME      # "MyApp"
echo $APP_VERSION   # "2.0.0"
```

---

## Common System Environment Variables

These are set by the system automatically:

| Variable | Example | Purpose |
|----------|---------|---------|
| `$HOME` | `/Users/benh` | Your home directory |
| `$USER` | `benh` | Your username |
| `$PWD` | `/Users/benh/project` | Current working directory |
| `$SHELL` | `/bin/zsh` | Your shell program |
| `$PATH` | `/usr/local/bin:/usr/bin:...` | Where to find programs |
| `$HOSTNAME` | `MacBook-Pro.local` | Computer name |
| `$LANG` | `en_US.UTF-8` | Language/locale |
| `$TERM` | `xterm-256color` | Terminal type |

### Access System Variables
```bash
echo "Home: $HOME"
echo "User: $USER"
echo "Shell: $SHELL"
echo "Directory: $PWD"
```

---

## Viewing Environment Variables

### List ALL variables
```bash
env                    # Show all environment variables
printenv               # Same as env
```

### Find specific variable
```bash
env | grep DATABASE    # Find variables with "DATABASE" in name
printenv | grep API    # Find variables with "API" in name
```

### Get single variable
```bash
echo $HOME
echo $PATH
```

---

## DevOps Use Cases

### 1. **Database Configuration**
```bash
export DATABASE_HOST="db.example.com"
export DATABASE_PORT="5432"
export DATABASE_NAME="myapp"
export DATABASE_USER="appuser"
export DATABASE_PASSWORD="secret"
```

Script reads these:
```bash
psql -h $DATABASE_HOST -p $DATABASE_PORT -d $DATABASE_NAME
```

### 2. **API Keys and Authentication**
```bash
export API_KEY="abc123xyz"
export API_SECRET="supersecret"
export AUTH_TOKEN="bearer_token_here"
```

### 3. **Application Configuration**
```bash
export APP_ENV="production"      # dev/staging/production
export LOG_LEVEL="info"          # error/warn/info/debug
export PORT="3000"               # Network port
export WORKERS="4"               # Number of processes
```

### 4. **Feature Flags**
```bash
export FEATURE_NEW_UI="true"
export FEATURE_BETA_API="false"
export DEBUG_MODE="false"
```

### 5. **Deployment Information**
```bash
export DEPLOY_DATE=$(date +%Y-%m-%d)
export DEPLOY_USER="devops"
export DEPLOY_VERSION="2.5.1"
export DEPLOY_REGION="us-east-1"
```

---

## Patterns and Techniques

### 1. **Fallback Values**
Use default if variable not set:

```bash
${VARIABLE:-default_value}
```

Example:
```bash
echo "Database: ${DATABASE_HOST:-localhost}"
# If DATABASE_HOST not set, uses "localhost"
```

### 2. **Error if variable missing**
Fail if variable not set:

```bash
${VARIABLE:?error message}
```

Example:
```bash
echo "API Key: ${API_KEY:?API_KEY not set!}"
# Exits with error if API_KEY not provided
```

### 3. **Check if variable exists**
```bash
if [ -z "$VARIABLE" ]; then
    echo "Variable not set"
else
    echo "Variable is: $VARIABLE"
fi
```

### 4. **Use variable with modifications**
```bash
export PATH="/new/bin:$PATH"           # Prepend to PATH
export JAVA_OPTS="-Xmx1024m $JAVA_OPTS" # Append to JAVA_OPTS
```

### 5. **Pass multiple to single command**
```bash
KEY=value1 SECRET=value2 SETTING=value3 ./script.sh
```

All three variables available only to script.sh.

---

## Real-World Examples

### Example 1: Development vs Production
```bash
#!/bin/bash

if [ "$APP_ENV" = "production" ]; then
    DATABASE_POOL_SIZE="20"
    CACHE_ENABLED="true"
    BACKUPS_ENABLED="true"
elif [ "$APP_ENV" = "development" ]; then
    DATABASE_POOL_SIZE="5"
    CACHE_ENABLED="false"
    BACKUPS_ENABLED="false"
fi

echo "Running in $APP_ENV mode"
echo "Database pool size: $DATABASE_POOL_SIZE"
```

Run:
```bash
APP_ENV="production" ./app.sh
APP_ENV="development" ./app.sh
```

### Example 2: Configuration from Environment
```bash
#!/bin/bash

# Read configuration from environment or use defaults
DATABASE_URL=${DATABASE_URL:-"postgresql://localhost/mydb"}
API_PORT=${API_PORT:-"3000"}
LOG_LEVEL=${LOG_LEVEL:-"info"}

echo "Configuration:"
echo "  Database: $DATABASE_URL"
echo "  Port: $API_PORT"
echo "  Log Level: $LOG_LEVEL"
```

Run with defaults:
```bash
./app.sh
# Output:
# Configuration:
#   Database: postgresql://localhost/mydb
#   Port: 3000
#   Log Level: info
```

Run with custom values:
```bash
DATABASE_URL="postgresql://prod-db/app" API_PORT="8080" ./app.sh
# Output:
# Configuration:
#   Database: postgresql://prod-db/app
#   Port: 8080
#   Log Level: info
```

### Example 3: Deployment Script
```bash
#!/bin/bash

APP_NAME=${APP_NAME:-"MyApp"}
APP_VERSION=${APP_VERSION:-"1.0.0"}
DEPLOY_ENV=${DEPLOY_ENV:-"staging"}
DEPLOY_USER=${DEPLOY_USER:-"unknown"}

echo "Deploying $APP_NAME v$APP_VERSION"
echo "Environment: $DEPLOY_ENV"
echo "Deployed by: $DEPLOY_USER"

if [ "$DEPLOY_ENV" = "production" ]; then
    echo "Creating database backup..."
    echo "Running health checks..."
    echo "Enabling monitoring..."
fi

echo "Deployment complete!"
```

Run:
```bash
# Default (staging)
./deploy.sh

# Production
APP_NAME="PaymentApp" APP_VERSION="3.0.0" DEPLOY_ENV="production" DEPLOY_USER="devops" ./deploy.sh
```

---

## .env Files (Configuration Files)

### Create .env file
```bash
cat > .env << 'EOF'
# Application Settings
APP_NAME="MyApplication"
APP_VERSION="2.0.0"

# Database
DATABASE_HOST="localhost"
DATABASE_PORT="5432"
DATABASE_NAME="myapp_db"

# API Configuration
API_PORT="3000"
API_TIMEOUT="30"

# Logging
LOG_LEVEL="info"
LOG_FILE="/var/log/app.log"

# Debugging
DEBUG="false"
EOF
```

### Load .env file
```bash
source .env
echo "App: $APP_NAME v$APP_VERSION"
echo "Database: $DATABASE_HOST:$DATABASE_PORT"
```

### .gitignore for secrets
```bash
# .gitignore
.env              # Never commit actual .env with secrets
.env.local        # Local overrides
*.key             # Private keys
*.secret          # Secrets
```

Use `.env.example` for documentation:
```bash
# .env.example (commit this, not .env)
APP_NAME="MyApp"
DATABASE_HOST="your_host_here"
DATABASE_PASSWORD="your_password_here"
API_KEY="your_key_here"
```

---

## Security Best Practices

### ❌ DON'T
```bash
# Never hardcode secrets in code
PASSWORD="mySecretPassword123"  # Bad!

# Never commit .env with real values
git add .env                    # Bad!

# Never pass secrets in command line (visible in process list)
curl -H "Authorization: secret123" ...  # Bad!
```

### ✅ DO
```bash
# Load secrets from environment variables
PASSWORD=$DATABASE_PASSWORD    # Good!

# Use .env files (git ignored) in development
source .env                    # Good!

# Use secrets management in production
# (AWS Secrets Manager, HashiCorp Vault, etc)

# Load from secure configuration system
PASSWORD=$(vault read secret/password)  # Good!
```

---

## Common Commands Reference

```bash
# CREATE AND USE
export VARIABLE="value"          # Create environment variable
VARIABLE="value" command         # For single command
source file.env                  # Load from file

# READ
echo $VARIABLE                   # Print variable
env                              # List all variables
printenv | grep PATTERN          # Find specific

# CHECK
[ -z "$VARIABLE" ]               # Check if empty
[ -n "$VARIABLE" ]               # Check if not empty
${VARIABLE:-default}             # Use default if not set
${VARIABLE:?error}               # Error if not set

# MODIFY PATH
export PATH="/new/path:$PATH"    # Add to beginning
export PATH="$PATH:/new/path"    # Add to end
```

---

## Learning Path

1. **Basics** - Create and access variables
   - `export VARIABLE="value"`
   - `echo $VARIABLE`

2. **DevOps** - Use for configuration
   - Set multiple variables
   - Load from .env files
   - Pass to scripts

3. **Advanced** - Conditional behavior
   - Environment-aware code
   - Fallback patterns
   - Error handling

4. **Production** - Security and scale
   - Secrets management
   - Audit logging
   - Integration with deployment systems

---

## Summary

**Environment variables are:**
- ✓ The primary configuration mechanism in Unix/Linux
- ✓ Essential for DevOps automation
- ✓ How to pass data to programs
- ✓ How to make flexible, reusable scripts
- ✓ How to keep secrets separate from code
- ✓ How to support multiple environments

**Key Commands:**
- `export VAR="value"` - Create environment variable
- `echo $VAR` - Read it
- `source .env` - Load from file
- `${VAR:-default}` - Use with fallback

**Real-world usage:**
- Configuration management
- Database connections
- API keys and tokens
- Feature flags
- Environment-aware behavior
- Deployment automation
- Multi-environment support

---

**Remember:** Environment variables are your configuration system. Use them instead of hardcoding values!
