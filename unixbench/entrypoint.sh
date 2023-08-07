#!/bin/bash
# echo "Container for test running"
cd byte-unixbench/UnixBench
mkdir results

export UB_OUTPUT_CSV="true"
make

arr=("$@")
numParallelRuns=${arr[0]}
numContainerInstances=${arr[1]}
numRunsInContainer=${arr[2]}
runtime=${arr[4]}
x=1
while [ $x -le $numRunsInContainer ]
do
	# echo "In same container, running test: $x"
	./Run
	x=$(( $x + 1 ))
done

cd ../..
echo "Tests runs complete!"
python3 mergeCSV.py "$numParallelRuns" "$numContainerInstances" "$numRunsInContainer" "$runtime"
