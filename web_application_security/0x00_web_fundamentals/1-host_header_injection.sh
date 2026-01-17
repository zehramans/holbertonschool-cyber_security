#!/bin/bash
curl -X POST $2 -d $3 -H "Host: $1" -i
