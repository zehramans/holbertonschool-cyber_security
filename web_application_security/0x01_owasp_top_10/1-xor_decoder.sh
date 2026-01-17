#!/bin/bash

# 1. Remove the {xor} prefix
input="${1#"{xor}"}"

# 2. Decode Base64 and XOR each byte with '_'
echo "$input" | base64 -d | perl -pe '$_ ^= "_" x length'
