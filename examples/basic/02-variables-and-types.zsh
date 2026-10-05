#!/bin/zsh
#
# Script Name: variables-and-types.zsh
# Description: Learn about variables and types in Zshell
# Author: Learning Example
# Date: 2024-10-05
# Version: 1.0
#
# Usage: ./variables-and-types.zsh
#

set -euo pipefail

echo "=== Zshell Variables and Types ==="

# String variables
name="Alice"
echo "String: $name"

# Numeric variables (stored as strings, but treated as numbers in arithmetic)
count=42
echo "Number: $count"

# Arrays
fruits=("apple" "banana" "orange")
echo "Array first element: ${fruits[1]}"  # zsh uses 1-based indexing!
echo "All fruits: ${fruits[@]}"

# Associative arrays (dictionaries)
declare -A colors
colors[red]="#FF0000"
colors[green]="#00FF00"
colors[blue]="#0000FF"
echo "Red color: ${colors[red]}"

# Environment variables
echo "Home directory: $HOME"
echo "Current user: $USER"
echo "Shell: $SHELL"

# Local vs Global variables
local_var="I'm local"  # Only available in current function
global_var="I'm global"

# Variable expansion tricks
path="/usr/local/bin"
echo "Expanded path: $path"

# Default values
missing_var="${UNDEFINED_VAR:-default_value}"
echo "Missing var with default: $missing_var"

echo "=== Done ==="
