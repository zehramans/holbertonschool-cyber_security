#!/bin/bash
nmap -sV --script=vulners -p80,443 $1
