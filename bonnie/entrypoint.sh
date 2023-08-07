#!/bin/bash
mkdir results
cd bonnie++_1.04
make
numRuns="$1"
x=1
while [ $x -le $numRuns ]
do
	# echo "In same container, running test: $x"
	./bonnie++ > ../results/"$(date +%s).csv"
	x=$(( $x + 1 ))
done
echo "Tests runs complete!"
cd ..
