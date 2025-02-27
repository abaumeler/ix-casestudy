#!/bin/bash

LOG_FILE="/var/log/errorlog.log"

# Ensure the log file exists
touch "$LOG_FILE"

echo "Starting ErrorLog service at $(date)" >> "$LOG_FILE"

# Array of sample error messages
ERROR_MESSAGES=(
  "ERROR: Failed to connect to database"
  "ERROR: Connection timeout after 30 seconds"
  "ERROR: Unable to process request - resource unavailable"
  "WARNING: Memory usage exceeding recommended threshold"
  "CRITICAL: Disk space critically low"
  "ERROR: Authentication failed - invalid credentials"
  "ERROR: Failed to load configuration file"
  "WARNING: API rate limit approaching threshold"
  "ERROR: Unexpected response from remote service"
  "CRITICAL: Service dependencies unavailable"
)

# Generate random error messages
while true; do
    # Get random error message
    ERROR_INDEX=$((RANDOM % ${#ERROR_MESSAGES[@]}))
    ERROR_MSG="${ERROR_MESSAGES[$ERROR_INDEX]}"
    
    # Log timestamp and error
    echo "[$(date)] $ERROR_MSG" >> "$LOG_FILE"
    
    # Sleep for a random interval between 5-15 seconds
    SLEEP_TIME=$((RANDOM % 10 + 5))
    sleep $SLEEP_TIME
done