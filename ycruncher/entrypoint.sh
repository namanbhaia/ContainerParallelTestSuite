#!/bin/bash
# echo "Running y-cruncher benchamrk"
tar -xf y-cruncher-v0.8.1.9317-dynamic.tar.xz
mv -v "y-cruncher v0.8.1.9317-dynamic/"* .
arr=("$@")
numParallelRuns=${arr[0]}
numContainerInstances=${arr[1]}
numRunsInContainer=${arr[2]}
runtime=${arr[4]}
resultsSubFolder=${arr[5]}
mkdir results
x=1
while [ $x -le $numRunsInContainer ]
do
	# echo "In same container, running test: $x"
	./y-cruncher skip-warnings bench 100m -od:0 -o "results/"
	x=$(( $x + 1 ))
done
# echo "Tests runs complete!"
python3 mergeCSV.py "$numParallelRuns" "$numContainerInstances" "$numRunsInContainer" "$runtime" "$resultsSubFolder"
# while :
# do
#  if [ -f "/stop" ]
#  then
#    exit
#  fi
#  sleep 1
# done

