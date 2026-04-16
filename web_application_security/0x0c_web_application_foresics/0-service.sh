#!/bin/bash

logfile="auth.log"

# Extract service names inside parentheses like (sshd:auth)
grep -oP '\(\K[^)]+' "$logfile" | cut -d: -f1 | sort | uniq -c | sort -nr
