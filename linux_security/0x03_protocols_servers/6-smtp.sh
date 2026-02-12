#!/bin/bash
postconf -n 2>/dev/null | grep -q "^smtpd_tls_security_level = \(may\|encrypt\)" && postconf -n | grep "^smtpd_tls_security_level" || echo "STARTTLS not configured"
