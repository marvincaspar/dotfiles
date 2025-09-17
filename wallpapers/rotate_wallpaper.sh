#!/bin/bash

exec >>"$HOME/Library/Logs/rotatewallpaper.log" 2>&1
echo "[$(date)] Running wallpaper rotation..."
osascript "$HOME/dotfiles/wallpapers/rotate_wallpaper.applescript"