#!/bin/bash
# echo "Running y-cruncher benchamrk"
tar -xf y-cruncher-v0.8.1.9317-dynamic.tar.xz
mv -v "y-cruncher v0.8.1.9317-dynamic/"* .
numRuns="$1"
x=1
while [ $x -le $numRuns ]
do
	# echo "In same container, running test: $x"
	./y-cruncher skip-warnings bench 100m -od:0 -o finalResults/
	x=$(( $x + 1 ))
done
echo "Tests runs complete!"
#while :
#do
#  if [ -f "/stop" ]
#  then
#    exit
#  fi
#  sleep 1
#done

