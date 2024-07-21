#!/bin/sh

set -e

# Determine the distribution ID
distro=$(grep -E "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')

# Construct the script path
script_path="$(dirname "$0")/${distro}/$1.sh"

# Check if the script exists and execute it, or exit with an error
if [ -x "$script_path" ]; then
    "$script_path"
else
    echo "Error: Script $script_path not found or not executable."
    exit 1
fi
