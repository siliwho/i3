#!/bin/bash
foo="$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')"
cmd=${foo::-2}
cmd="$(echo $cmd | cut -c 1-4)%"
echo "CPU $cmd"

