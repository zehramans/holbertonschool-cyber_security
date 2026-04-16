#!/bin/bash

# This script parses auth logs to identify services being targeted.
# Usage: ./0-service.sh /var/log/auth.log

LOG_FILE=${1:-/var/log/auth.log}

# 1. Filter lines containing service/PAM information
# 2. Extract the process name (between '(' and ':')
# 3. Count occurrences and format
grep "pam_unix" "$LOG_FILE" | \
awk -F'[:()]' '{print $2}' | \
sort | uniq -c | sort -rn
