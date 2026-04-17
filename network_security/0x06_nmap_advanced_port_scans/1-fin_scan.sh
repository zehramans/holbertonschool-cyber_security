#!/bin/bash
sudo nmap -sF -p80,85 -T2 -f $1
