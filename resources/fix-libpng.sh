#! /usr/bin/env bash

if [[ -z "$*" ]]; then
	FILES=$(find . -name "*.png")
else
	FILES="$*"
fi

for file in $FILES
do
	echo "Strip $file"
	convert "$file" -strip "$file"
done
