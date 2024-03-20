#!/bin/bash

# Usage check
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <source-folder-path>"
    exit 1
fi

SOURCE_FOLDER="$1"
DEST_FOLDER="$HOME/.config"

# Check if source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
    echo "Error: Source folder '$SOURCE_FOLDER' does not exist."
    exit 2
fi

# Copying files
echo "Starting to copy files from '$SOURCE_FOLDER' to '$DEST_FOLDER'..."

find "$SOURCE_FOLDER" -type f | while read file; do
    # Constructing the destination path
    dest_path="$DEST_FOLDER/$(basename "$(dirname "$file")")/$(basename "$file")"
    
    # Ensure the destination directory exists
    mkdir -p "$(dirname "$dest_path")"
    
    # Copying file
    cp -v "$file" "$dest_path"
done

echo "File copy operation completed."

# Check if the folder is specifically for 'kitty' and restart kitty if it is
if [[ "$SOURCE_FOLDER" == *"kitty"* ]]; then
    echo "Detected kitty configuration changes. Restarting kitty..."
    # Killing all current kitty instances
    pkill kitty
    # Starting kitty again
    nohup kitty &>/dev/null &
    echo "kitty has been restarted to apply the changes."
fi
