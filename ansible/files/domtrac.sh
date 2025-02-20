#!/bin/bash

LOG_FILE="/var/log/domtrac.log"

# Ensure the log file exists
touch "$LOG_FILE"

echo "Starting domtrac at $(date)" >> "$LOG_FILE"

while true; do
    echo "Timestamp: $(date) processing documents" >> "$LOG_FILE"
    sleep 10
done