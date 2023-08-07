#!/bin/bash
# echo "Building linpack executable from C code"
gcc -o linpack -O3 -march=native -lm linpack.c
mkdir results
arr=("$@")
numParallelRuns=${arr[0]}
numContainerInstances=${arr[1]}
numRunsInContainer=${arr[2]}
runtime=${arr[4]}
x=1
while [ $x -le $numRunsInContainer ]
do
	# echo "In same container, running test: $x"
	./linpack > results/"$(date +%s).csv"
	# Alternate way of naming intermediate files. Not using anymore as it does not maintain chronology.
	# ./linpack > results/"$RANDOM.csv"
	x=$(( $x + 1 ))
done
# echo "Tests runs complete!"
python3 mergeCSV.py "$numParallelRuns" "$numContainerInstances" "$numRunsInContainer" "$runtime"

