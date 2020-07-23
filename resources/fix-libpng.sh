#! /usr/bin/env bash

if [[ -z "$*" ]]; then
	FILES=`find . -name "*.png" -print0`
else
	FILES="$*"
fi

echo $FILES | while read -d $'\0' file; do convert "$file" -strip "$file"; done 
