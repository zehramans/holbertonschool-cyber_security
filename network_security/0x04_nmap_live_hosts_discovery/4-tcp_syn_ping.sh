#!/bin/bash
sudo nmap -PS -p 22,80,443 -sn $1
