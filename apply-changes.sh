#!/bin/bash

# Usage check
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <source-folder-path>"
    exit 1
fi

SOURCE_FOLDER="$1"
DEST_FOLDER="$HOME/.config"
ALACRITTY_VERSION=$(alacritty --version 2>/dev/null | grep -oP '\d+\.\d+' || echo "0.0")

# Function to convert version to a comparable number
version_to_number() {
    echo "$1" | awk -F. '{printf "%d%03d", $1, $2}'
}

# Check if source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
    echo "Error: Source folder '$SOURCE_FOLDER' does not exist."
    exit 2
fi

# Determine the folder name from SOURCE_FOLDER
FOLDER_NAME=$(basename "$SOURCE_FOLDER")

# Copying files and converting if necessary
echo "Starting to process files from '$SOURCE_FOLDER'..."

ALACRITTY_NEEDS_CONVERSION=$(version_to_number "$ALACRITTY_VERSION")
ALACRITTY_CONVERSION_THRESHOLD=$(version_to_number "0.13")

find "$SOURCE_FOLDER" -type f | while read file; do
    basename=$(basename "$file")
    dirname=$(basename "$(dirname "$file")")
    dest_path="$DEST_FOLDER/$dirname/$basename"

    # Ensure the destination directory exists
    mkdir -p "$(dirname "$dest_path")"
    
    # Check if it's the alacritty directory and needs conversion
    if [[ "$FOLDER_NAME" == "alacritty" && "$ALACRITTY_NEEDS_CONVERSION" -lt "$ALACRITTY_CONVERSION_THRESHOLD" ]]; then
        if [[ "$basename" == *.toml ]]; then
            # File is a TOML config; convert to YAML
            echo "Converting $file to YAML format for Alacritty compatibility."
            yaml_file_path="${dest_path%.*}.yml"
            python toml_to_yaml.py "$file" "$yaml_file_path"
        fi
    elif [[ "$FOLDER_NAME" == "kitty" ]]; then
        # Directly copy file for kitty
        cp -v "$file" "$dest_path"
    else
        # Directly copy file for other folders
        cp -v "$file" "$dest_path"
    fi
done

echo "File processing operation completed."

# Specific operations for kitty
if [[ "$FOLDER_NAME" == "kitty" ]]; then
    echo "Detected kitty configuration changes. Restarting kitty..."
    # Killing all current kitty instances
    pkill kitty
    # Starting kitty again
    nohup kitty &>/dev/null &
    echo "kitty has been restarted to apply the changes."
fi

