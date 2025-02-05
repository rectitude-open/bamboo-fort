#!/bin/bash

# Define the directory where log files are stored
LOG_DIR="/var/log/lynis/events"

# Check if the directory exists
if [[ ! -d "$LOG_DIR" ]]; then
  echo "Error: Directory $LOG_DIR does not exist."
  exit 1
fi

# Find the latest file in the directory
LATEST_FILE=$(ls -t "$LOG_DIR"/*.log 2>/dev/null | head -n 1)

# Check if a log file exists
if [[ -z "$LATEST_FILE" ]]; then
  echo "Error: No log files found in $LOG_DIR."
  exit 1
fi

# Open the latest file with vi
echo "Opening the latest log file: $LATEST_FILE"
less -R "$LATEST_FILE"
