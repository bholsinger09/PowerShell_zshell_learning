#!/bin/zsh
# Wrapper script for parsing reports and generating dashboard data
# This script is called by daily-automation.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_PARSER="$SCRIPT_DIR/parse-reports.py"

if [[ ! -f "$PYTHON_PARSER" ]]; then
    echo "Error: parse-reports.py not found at $PYTHON_PARSER"
    exit 1
fi

python3 "$PYTHON_PARSER"
