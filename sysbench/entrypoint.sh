#!/bin/bash
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
	filename="results/SysbenchRun_$(date +%s)_${runtime}_${numParallelRuns}_${numContainerInstances}_${numRunsInContainer}_${parallelRunId}.prof"
	touch filename
	sysbench cpu --cpu-max-prime=20000000 --threads=2 --events=10 run > $filename
	x=$(( $x + 1 ))
done
cd ..
python3 mergeCSV.py "$numParallelRuns" "$numContainerInstances" "$numRunsInContainer" "$runtime" "$resultsSubFolder"
# echo "Tests runs complete!"
# while :
# do
#  if [ -f "/stop" ]
#  then
#    exit
#  fi
#  sleep 1
# done