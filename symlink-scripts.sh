#!/usr/bin/env bash
set -euo pipefail

# Define the directory containing your scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"

# Define the target directory for symlinks
TARGET_DIR="/usr/local/bin"

chmod +x "$SCRIPT_DIR"/*

# Loop through all scripts in the folder
for script in "$SCRIPT_DIR"/*; do
    # Only process files and skip directories
    if [ -f "$script" ]; then
        # Get the script's base name
        script_name="$(basename "$script")"
        
        # Create or update the symlink in /usr/local/bin
        ln -sf "$script" "$TARGET_DIR/$script_name"
        echo "Symlinked: $script -> $TARGET_DIR/$script_name"
    fi
done

# Manually symlink pi agent sandbox script to have agent sandbox config stored in one folder
ln -sf "agent-sandbox/pi" "$TARGET_DIR/pi"

echo "All scripts have been symlinked."
