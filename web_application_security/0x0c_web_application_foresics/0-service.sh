#!/bin/bash
grep "pam_unix" "$1" | awk -F'[:()]' '{print $2}' | sort | uniq -c | sort -rn
