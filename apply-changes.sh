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
    
    if [[ "$dirname" == "alacritty" && "$basename" == *.toml && "$ALACRITTY_NEEDS_CONVERSION" -lt "$ALACRITTY_CONVERSION_THRESHOLD" ]]; then
        # Alacritty version is less than 0.13, and file is a TOML config; convert to YAML
        echo "Converting $file to YAML format for Alacritty compatibility."
        yaml_file="${file%.*}.yaml"
        python toml_to_yaml.py "$file" "$yaml_file"
        cp -v "$yaml_file" "$dest_path"
    else
        # Directly copy file
        cp -v "$file" "$dest_path"
    fi
done

echo "File processing operation completed."

# Check if the folder is specifically for 'kitty' and restart kitty if it is
if [[ "$SOURCE_FOLDER" == *"kitty"* ]]; then
    echo "Detected kitty configuration changes. Restarting kitty..."
    # Killing all current kitty instances
    pkill kitty
    # Starting kitty again
    nohup kitty &>/dev/null &
    echo "kitty has been restarted to apply the changes."
fi

