-- Get the current username from the shell
set username to do shell script "echo $USER"

-- Build folder path
set wallpaperFolderPOSIX to "/Users/" & username & "/dotfiles/wallpapers"
set wallpaperFolder to POSIX file wallpaperFolderPOSIX as alias

-- Collect image files and resolve to aliases immediately
tell application "Finder"
    set imageFiles to every file of wallpaperFolder whose name extension is in {"jpg", "jpeg", "png"}
    set imagePaths to {}
    repeat with f in imageFiles
        set end of imagePaths to (POSIX path of (f as alias))
    end repeat
end tell

-- Pick one at random
set chosenPath to some item of imagePaths

-- Apply to all desktops at once
tell application "System Events"
    set picture of every desktop to POSIX file chosenPath
end tell
