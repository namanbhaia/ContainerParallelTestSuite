#!/bin/bash
# echo "Building stream executable from C code"
gcc -O stream.c -o stream
mkdir results
arr=("$@")
numParallelRuns=${arr[0]}
numContainerInstances=${arr[1]}
numRunsInContainer=${arr[2]}
runtime=${arr[4]}
resultsSubFolder=${arr[5]}
x=1
while [ $x -le $numRunsInContainer ]
do
	# echo "In same container, running test: $x"
	./stream > results/"$(date +%s).csv"
	x=$(( $x + 1 ))
done
# echo "Tests runs complete!"
python3 mergeCSV.py "$numParallelRuns" "$numContainerInstances" "$numRunsInContainer" "$runtime" "$resultsSubFolder"

