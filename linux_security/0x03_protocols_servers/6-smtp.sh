#!/bin/bash
awk -F'=' '/^smtpd_tls_security_level/ {gsub(/ /, "", $2); val=$2} END {print (val == "" || val == "none") ? "STARTTLS not configured" : "smtpd_tls_security_level =" val}' /etc/postfix/main.cf
