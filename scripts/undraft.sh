#!/bin/sh

# Select a file
file=$(find content/posts -name "*.md" | fzf --prompt="Select a draft to undraft: ")

# Exit if no file is selected
if [ -z "$file" ]; then
    echo "Error: No file selected. Exiting."
    exit 1
fi

# Convert the file path to an absolute path
file=$(realpath "$file")

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "Error: Selected file does not exist: $file"
    exit 1
fi

# Get the current date
now="$(date "+%Y-%m-%d")"

# Extract the date and draft status from the file
file_date=$(grep -oE '^date: "[0-9]{4}-[0-9]{2}-[0-9]{2}"' "$file" | cut -d '"' -f 2)
draft_status=$(grep -oE '^draft: (true|false)' "$file" | cut -d ' ' -f 2)

# Determine epoch time for macOS or GNU date
if date -j >/dev/null 2>&1; then
    # macOS
    file_date_epoch=$(date -j -f "%Y-%m-%d" "$file_date" +%s)
    now_epoch=$(date +%s)
else
    # GNU
    file_date_epoch=$(date -d "$file_date" +%s)
    now_epoch=$(date +%s)
fi

# Prepare sed commands
sed_commands=""

# Update date if it is in the past
if [ "$file_date_epoch" -lt "$now_epoch" ]; then
    if [ "$file_date" != "$now" ]; then
        sed_commands="s/^date: \"[0-9]{4}-[0-9]{2}-[0-9]{2}\"/date: \"${now}\"/;"
        echo "Date updated to: ${now}"
    else
        echo "Date is already set to the current date. No update needed."
    fi
fi

# Update draft status if it is true
if [ "$draft_status" = "true" ]; then
    sed_commands="${sed_commands}s/^draft: true$/draft: false/;"
    echo "Draft status set to false"
else
    echo "Draft status is already false. No update needed."
fi

# Apply sed commands if any
if [ -n "$sed_commands" ]; then
    sed -i -E "$sed_commands" "$file"
    echo "File updated: $file"
fi

exit 0
