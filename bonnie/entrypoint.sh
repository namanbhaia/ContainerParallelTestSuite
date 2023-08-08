#!/bin/bash
mkdir results
numRuns="$1"
x=1
while [ $x -le $numRuns ]
do
	# echo "In same container, running test: $x"
	bonnie++ -d /results -s 20G -n 0 -m TEST -f -b > ../results/"$(date +%s).csv" -u root:root
	x=$(( $x + 1 ))
done
echo "Tests runs complete!"
