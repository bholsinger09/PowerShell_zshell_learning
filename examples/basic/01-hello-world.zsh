#!/bin/zsh
#
# Script Name: hello-world.zsh
# Description: Your first Zshell script
# Author: Learning Example
# Date: 2024-10-05
# Version: 1.0
#
# Usage: ./hello-world.zsh
#

set -euo pipefail

# Function to print messages
greet() {
    local name="${1:-World}"
    echo "Hello, $name!"
}

# Main execution
greet "Zshell Developer"
echo "This is your first Zshell script!"
