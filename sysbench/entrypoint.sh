#!/bin/bash
mkdir results
arr=("$@")
numParallelRuns=${arr[0]}
numContainerInstances=${arr[1]}
numRunsInContainer=${arr[2]}
isCpuTest=${arr[3]}
runtime=${arr[5]}
resultsSubFolder=${arr[6]}
x=1
while [ $x -le $numRunsInContainer ]
do
	# echo "In same container, running test: $x"
	filename="results/SysbenchRun_$(date +%s)_${runtime}_${numParallelRuns}_${numContainerInstances}_${numRunsInContainer}.prof"
	touch filename
	if  [ "$isCpuTest" = "true" ]
	then
		sysbench cpu --cpu-max-prime=20000000 --threads=2 --events=10 --time=0 run > $filename
	else
		sysbench memory run > $filename
	fi
	x=$(( $x + 1 ))
done
cd ..
if  [ "$isCpuTest" = "true" ]
then
	python3 mergeCSVCPU.py "$numParallelRuns" "$numContainerInstances" "$numRunsInContainer" "$runtime" "$resultsSubFolder"
else
	python3 mergeCSVMemory.py "$numParallelRuns" "$numContainerInstances" "$numRunsInContainer" "$runtime" "$resultsSubFolder"
fi
# echo "Tests runs complete!"
# while :
# do
#  if [ -f "/stop" ]
#  then
#    exit
#  fi
#  sleep 1
# done