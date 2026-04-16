#!/bin/bash

# Update this path to the correct log file found via the find command
LOG_FILE="/var/log/auth.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: $LOG_FILE not found. Please verify the log path."
    exit 1
fi

# The logic remains the same to parse the service
grep "pam_unix" "$LOG_FILE" | awk -F'[:()]' '{print $2}' | sort | uniq -c | sort -rn
