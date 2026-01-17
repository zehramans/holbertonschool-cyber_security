#!/bin/bash
input=$1

clean_input="${input#"{xor}"}"

base64 -d $clean_input
