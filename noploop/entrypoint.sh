#!/bin/bash
# echo "Building noploop executable from assembly"
gcc -o noploop noploop.s
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
	{ /usr/bin/time -f "Real %e\nUser %U\nSys %S" ./noploop; } 2>> temp.csv
	x=$(( $x + 1 ))
done
# echo "Tests runs complete!"
python3 mergeCSV.py "$numParallelRuns" "$numContainerInstances" "$numRunsInContainer" "$runtime" "$resultsSubFolder"
