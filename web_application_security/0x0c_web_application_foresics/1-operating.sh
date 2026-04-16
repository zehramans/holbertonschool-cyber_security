#!/bin/bash

dmesg -H | grep -m 1 "Linux version" | sed 's/^\[[^]]*\] //'
