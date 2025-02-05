#!/bin/bash

REPORT_DIR="/var/log/lynis/reports"
EVENT_DIR="/var/log/lynis/events"

mkdir -p "$REPORT_DIR"
mkdir -p "$EVENT_DIR"

DATE=$(date +%Y%m%d_%H%M%S)
REPORT_NAME="${DATE}.dat"
EVENT_NAME="${DATE}.log"

echo "Running Lynis Audit..."
lynis audit system --nocolors > "$EVENT_DIR/$EVENT_NAME"

DEFAULT_REPORT="/var/log/lynis-report.dat"

if [ -f "$DEFAULT_REPORT" ]; then
  cp "$DEFAULT_REPORT" "$REPORT_DIR/$REPORT_NAME"
  echo "Report saved to: $REPORT_DIR/$REPORT_NAME"
  echo "Event saved to: $EVENT_DIR/$EVENT_NAME"
else
  echo "Lynis report not found at $DEFAULT_REPORT."
fi
