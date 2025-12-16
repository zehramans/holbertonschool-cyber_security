#!/bin/bash
users = $1
ps -u $users | grep -v "      0     0"
