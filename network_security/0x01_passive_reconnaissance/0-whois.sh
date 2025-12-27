#!/bin/bash
whois "$1" | awk '/^(Registrant|Admin|Tech)/{split($0,a,": ");NR>1 && printf("\n");printf "%s,%s%s",a[1],a[2],a[1]~"Street"?" ":""}' > "$1.csv"
