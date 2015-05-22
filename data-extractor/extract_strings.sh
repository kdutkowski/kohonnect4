#!/bin/sh
inputFile=$1
basename=$(basename $inputFile .txt)
cat $inputFile | grep -o '[0-9]\{5,\}' | sort | uniq -u > $basename"_strings.txt"
