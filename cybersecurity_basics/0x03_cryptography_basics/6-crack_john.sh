#!/bin/bash
john --wordlist=/usr/share/wordlists/rockyou.txt --format=RAW-SHA256 "$1"
