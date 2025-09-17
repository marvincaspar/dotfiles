#!/bin/bash

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

ln -sf ~/dotfiles/wallpapers/com.user.rotatewallpaper.plist ~/Library/LaunchAgents/com.user.rotatewallpaper.plist

echo "All scripts have been symlinked."
