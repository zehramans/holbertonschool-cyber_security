#!/bin/bash

# 1. Take the input argument
input=$1

# 2. Remove the "{xor}" prefix if it exists
clean_input="${input#"{xor}"}"

# 3. Pipe the clean string into base64
echo "$clean_input" | base64 -d
