#! /usr/bin/env bash
find . -name "*.png" -print0 | while read -d $'\0' file; do convert "$file" -strip "$file"; done 
