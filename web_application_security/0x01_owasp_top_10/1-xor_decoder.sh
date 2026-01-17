#!/bin/bash
input="${1#"{xor}"}"

echo "$input" | base64 -d | perl -pe '$_ ^= "_" x length'
