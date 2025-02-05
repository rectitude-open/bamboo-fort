#!/bin/bash

# Define the directory where Lynis reports are stored
REPORT_DIR="/var/log/lynis/reports"

# Get the 5 most recent files, sorted by modification time
FILES=($(ls -t "$REPORT_DIR"/*.dat | head -n 5))

# Check if there are at least 2 files
if [[ ${#FILES[@]} -lt 2 ]]; then
  echo -e "\033[31mError: Not enough report files in $REPORT_DIR. At least 2 are needed.\033[0m"
  exit 1
fi

# List the files with indices
echo -e "\033[36mAvailable reports (sorted by last modified):\033[0m"
for i in "${!FILES[@]}"; do
  echo "$((i + 1)). $(basename "${FILES[i]}")"
done

# Prompt the user to select files by index
read -p "Select the OLD report by number (1-${#FILES[@]}): " OLD_INDEX
read -p "Select the NEW report by number (1-${#FILES[@]}): " NEW_INDEX

# Validate user input
if ! [[ "$OLD_INDEX" =~ ^[1-5]$ ]] || ! [[ "$NEW_INDEX" =~ ^[1-5]$ ]]; then
  echo -e "\033[31mError: Invalid selection. Please enter a number between 1 and 5.\033[0m"
  exit 1
fi

# Get the paths of the selected files
OLD_REPORT="${FILES[$((OLD_INDEX - 1))]}"
NEW_REPORT="${FILES[$((NEW_INDEX - 1))]}"

# Ensure the selected files are not the same
if [[ "$OLD_REPORT" == "$NEW_REPORT" ]]; then
  echo -e "\033[31mError: You selected the same file for both OLD and NEW reports.\033[0m"
  exit 1
fi

# Extract warnings and suggestions using awk
OLD_WARNINGS=$(awk -F'=\\[|\\]' '/^warning\[\]/ {print $2}' "$OLD_REPORT")
NEW_WARNINGS=$(awk -F'=\\[|\\]' '/^warning\[\]/ {print $2}' "$NEW_REPORT")
OLD_SUGGESTIONS=$(awk -F'=\\[|\\]' '/^suggestion\[\]/ {print $2}' "$OLD_REPORT")
NEW_SUGGESTIONS=$(awk -F'=\\[|\\]' '/^suggestion\[\]/ {print $2}' "$NEW_REPORT")

# Compare warnings and suggestions
echo -e "\033[33mComparing warnings and suggestions between $(basename "$OLD_REPORT") and $(basename "$NEW_REPORT")...\033[0m"

# Compare warnings
echo -e "\033[35m=== Warnings ===\033[0m"
comm -23 <(echo "$OLD_WARNINGS" | sort) <(echo "$NEW_WARNINGS" | sort) | sed 's/^/Removed: /'
comm -13 <(echo "$OLD_WARNINGS" | sort) <(echo "$NEW_WARNINGS" | sort) | sed 's/^/Added: /'

# Compare suggestions
echo -e "\033[34m=== Suggestions ===\033[0m"
comm -23 <(echo "$OLD_SUGGESTIONS" | sort) <(echo "$NEW_SUGGESTIONS" | sort) | sed 's/^/Removed: /'
comm -13 <(echo "$OLD_SUGGESTIONS" | sort) <(echo "$NEW_SUGGESTIONS" | sort) | sed 's/^/Added: /'
