#!/bin/bash

echo "Container for test running"
echo "Building container for llcbench"
tar -xf llcbench.tar.gz
cd llcbench
echo "--------------------- Cleaning all resources"
make distclean
echo "--------------------- Building linux-mpich"
make linux-mpich
echo "--------------------- Building cache-bench"
make cache-bench
echo "--------------------- Building cache-run"
make cache-run
echo "--------------------- Generating scripts to export"
make cache-script
while :
do
  if [ -f "/stop" ]
  then
    exit
  fi
  sleep 1
done
