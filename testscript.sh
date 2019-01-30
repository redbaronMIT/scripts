#!/bin/bash 
# a test script
name="REVL0111"
for f in $name.*; do 
    ext="${f##*.}" 
	echo $f
    mv "$f" "newname.$ext"
done
