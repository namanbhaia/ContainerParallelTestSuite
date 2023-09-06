#!/bin/bash

## File to build and run all benchmark containers

# Help Menu
help_menu() {
    echo "Help Menu: "
    echo "Use the following options with runBenchmarksLoop script:"
    echo "-e to remove all images/instances and exit"
    echo "-r to rebuild all container images for benchmakrs mentioned after"
    echo "-l to run linpack benchmark"
    echo "-n to run noploop benchmark"
    echo "-u to run unixbench benchmark"
    echo "-y to run y-cruncher benchmark"
    echo "-b to run bonnie++ benchmark"
    echo "-c to run cachebench benchmark"
    echo "After choosing benchamark to run, please provide repetitions as 'x y z'"
    echo "Here, x is number of parallel runs, y is number of containers in serial, and z is number of runs in each container"
    exit
}

clean() {
    # Stopping docker containers
    running_docker_containers=$(sudo docker ps -a | grep -E '.*(capstone+)+.*' | awk '{print $1}')
    if [ -n "$running_docker_containers" ]; then
        # echo "---------- Stopping Docker containers ----------"
        for container_id in $running_docker_containers; do
            sudo docker stop $container_id > /dev/null
            sudo docker rm $container_id > /dev/null
        done
    fi

    #echo "---------- Displaying all running Docker instances after cleanup ----------"
    #echo sudo docker ps -a
}

run_linpack() {
    # Linpack Benchmark
    arr=$1
    numContainerInstances=${arr[1]}
    runtime=${arr[4]}
    logFile=${arr[6]}
    logEntry=$2
    logEntry+=",$(date +%s)";
    x=1
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we sim+ply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/finalResults -e LINPACK_ARRAY_SIZE=600 --memory="4000m" --cpus="2" capstone_linpack "${arr[@]}"
        x=$(($x + 1))
    done
    logEntry+=",$(date +%s)";
    echo $logEntry >> $logFile
}

run_linpack_parallel() {
    echo "Running Linpack benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    runtime=${arr[4]}
    # Check if Linpack container image exists or if rebuild is requested
    linpack_docker_images=$(sudo docker images | grep -E '.*(capstone_linpack)+.*' | awk '{print $1}')
    if [ ! -n "$linpack_docker_images" ] || [ "$rebuild" = "true" ]; then
        echo "Building Linpack container"
        sh ./buildContainers.sh --linpack
    fi
    currTimeStamp=$(date +%s)
    subFolderName="finalResults/Linpack_${currTimeStamp}_${runtime}_${numParallelRuns}_${arr[1]}_${arr[2]}"
    mkdir $subFolderName
    logFile="${subFolderName}/Linpack_RunLog.txt"
    arr+=($subFolderName $logFile)
    touch $logFile
    echo "ParallelBranch,StartTime,EndTime" > $logFile
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_linpack $arr $x &
        PID="$!"
        PID_LIST+="$PID "
        x=$(($x + 1))
    done    
    wait
    cp "linpack/mergeMergedCSV.py" "${subFolderName}/mergeMergedCSV.py"
    cd $subFolderName
    python3 mergeMergedCSV.py
    cd ../..
}

run_noploop() {
    # Noploop Benchmark
    arr=$1
    numContainerInstances=${arr[1]}
    runtime=${arr[4]}
    logFile=${arr[6]}
    logEntry=$2
    logEntry+=",$(date +%s)";
    x=1
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we simply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/finalResults --memory="4000m" --cpus="2" capstone_noploop "${arr[@]}"
        x=$(($x + 1))
    done
    logEntry+=",$(date +%s)";
    echo $logEntry >> $logFile
}

run_noploop_parallel() {
    echo "Running Noploop benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    runtime=${arr[4]}
    # Check if Noploop container image exists or if rebuild is requested
    noploop_docker_images=$(sudo docker images | grep -E '.*(capstone_noploop)+.*' | awk '{print $1}')
    if [ ! -n "$noploop_docker_images" ] || [ "$rebuild" = "true" ]; then
        echo "Building Noploop container"
        sh ./buildContainers.sh --noploop
    fi
    currTimeStamp=$(date +%s)
    subFolderName="finalResults/Noploop_${currTimeStamp}_${runtime}_${numParallelRuns}_${arr[1]}_${arr[2]}"
    mkdir $subFolderName
    logFile="${subFolderName}/Noploop_RunLog.txt"
    arr+=($subFolderName $logFile)
    touch $logFile
    echo "ParallelBranch,StartTime,EndTime" > $logFile
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_noploop $arr $x &
        PID="$!"
        PID_LIST+="$PID "
        x=$(($x + 1))
    done
    wait
    cp "noploop/mergeMergedCSV.py" "${subFolderName}/mergeMergedCSV.py"
    cd $subFolderName
    python3 mergeMergedCSV.py
    cd ../..
}

run_unixbench() {
    # Unixbench Benchmark
    arr=$1
    numContainerInstances=${arr[1]}
    runtime=${arr[4]}
    logFile=${arr[6]}
    logEntry=$2
    logEntry+=",$(date +%s)";
    x=1
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we simply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/finalResults --memory="4000m" --cpus="2" capstone_unixbench "${arr[@]}"
        x=$(($x + 1))
    done
    logEntry+=",$(date +%s)";
    echo $logEntry >> $logFile
}

run_unixbench_parallel() {
    echo "Running Unixbench benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    runtime=${arr[4]}
    # Check if Unixbench container image exists or if rebuild is requested
    unixbench_docker_images=$(sudo docker images | grep -E '.*(capstone_unixbench)+.*' | awk '{print $1}')
    if [ ! -n "$unixbench_docker_images" ] || [ "$rebuild" = "true" ]; then
        echo "Building Unixbench container"
        sh ./buildContainers.sh --unixbench
    fi
    currTimeStamp=$(date +%s)
    subFolderName="finalResults/Unicbench_${currTimeStamp}_${runtime}_${numParallelRuns}_${arr[1]}_${arr[2]}"
    mkdir $subFolderName
    logFile="${subFolderName}/Unixbench_RunLog.txt"
    arr+=($subFolderName $logFile)
    touch $logFile
    echo "ParallelBranch,StartTime,EndTime" > $logFile
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_unixbench $arr $x &
        PID="$!"
        PID_LIST+="$PID "
        x=$(($x + 1))
    done
    wait
    # cp "unixbench/mergeMergedCSV.py" "${subFolderName}/mergeMergedCSV.py"
    # cd $subFolderName
    # python3 mergeMergedCSV.py
    # cd ../..
}

run_sysbench() {
    # Sysbench Benchmark
    #TODO: Currently does not support running the benchmark n times in each container. This is because the container image is pulled from the internet
    arr=$1
    numContainerInstances=${arr[1]}
    runtime=${arr[4]}
    logFile=${arr[6]}
    logEntry=$2
    logEntry+=",$(date +%s)";
    x=1
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we simply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/finalResults --memory="4000m" --cpus="2" capstone_sysbench "${arr[@]}"
        x=$(($x + 1))
    done
    logEntry+=",$(date +%s)";
    echo $logEntry >> $logFile
}

run_sysbench_parallel() {
    echo "Running Sysbench benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    runtime=${arr[4]}
    # Check if Sysbench container image exists or if rebuild is requested
    sysbench_docker_images=$(sudo docker images | grep -E '.*(capstone_sysbench)+.*' | awk '{print $1}')
    if [ ! -n "$sysbench_docker_images" ] || [ "$rebuild" = "true" ]; then
        echo "Building Sysbench container"
        sh ./buildContainers.sh --sysbench
    fi
    currTimeStamp=$(date +%s)
    subFolderName="finalResults/Sysbench_${currTimeStamp}_${runtime}_${numParallelRuns}_${arr[1]}_${arr[2]}"
    mkdir $subFolderName
    logFile="${subFolderName}/Sysbench_RunLog.txt"
    arr+=($subFolderName $logFile)
    touch $logFile
    echo "ParallelBranch,StartTime,EndTime" > $logFile
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_sysbench $arr $x &
        PID="$!"
        PID_LIST+="$PID "
        x=$(($x + 1))
    done
    wait
    cp "sysbench/mergeMergedCSV.py" "${subFolderName}/mergeMergedCSV.py"
    cd $subFolderName
    python3 mergeMergedCSV.py
    cd ../..
}

run_ycruncher() {
    # Y-Cruncher Benchmark
    arr=$1
    numContainerInstances=${arr[1]}
    runtime=${arr[4]}
    logFile=${arr[6]}
    logEntry=$2
    logEntry+=",$(date +%s)";
    x=1
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we simply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/finalResults --memory="4000m" --cpus="2" capstone_ycruncher "${arr[@]}"
        x=$(($x + 1))
    done
    logEntry+=",$(date +%s)";
    echo $logEntry >> $logFile
}

run_ycruncher_parallel() {
    echo "Running Y-Cruncher benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    runtime=${arr[4]}
    # Check if Y-Cruncher container image exists or if rebuild is requested
    ycruncher_docker_images=$(sudo docker images | grep -E '.*(capstone_ycruncher)+.*' | awk '{print $1}')
    if [ ! -n "$ycruncher_docker_images" ] || [ "$rebuild" = "true" ]; then
        echo "Building Y-Cruncher container"
        sh ./buildContainers.sh --ycruncher
    fi
    currTimeStamp=$(date +%s)
    subFolderName="finalResults/YCruncher_${currTimeStamp}_${runtime}_${numParallelRuns}_${arr[1]}_${arr[2]}"
    mkdir $subFolderName
    logFile="${subFolderName}/Ycruncher_RunLog.txt"
    arr+=($subFolderName $logFile)
    touch $logFile
    echo "ParallelBranch,StartTime,EndTime" > $logFile
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_ycruncher $arr $xs &
        PID="$!"
        PID_LIST+="$PID "
        x=$(($x + 1))
    done
    wait
    cp "ycruncher/mergeMergedCSV.py" "${subFolderName}/mergeMergedCSV.py"
    cd $subFolderName
    python3 mergeMergedCSV.py
    cd ../..
}

run_bonnie() {
    # Bonnie++ Benchmark
    arr=$1
    numContainerInstances=${arr[1]}
    runtime=${arr[4]}
    logFile=${arr[6]}
    logEntry=$2
    logEntry+=",$(date +%s)";
    x=1
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we simply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/finalResults --memory="4000m" --cpus="2" capstone_bonnie "${arr[@]}"
        x=$(($x + 1))
    done
    logEntry+=",$(date +%s)";
    echo $logEntry >> $logFile
}

run_bonnie_parallel() {
    echo "Running Bonnie++ benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    runtime=${arr[4]}
    # Check if Bonnie++ container image exists or if rebuild is requested
    bonnie_docker_images=$(sudo docker images | grep -E '.*(capstone_bonnie)+.*' | awk '{print $1}')
    if [ ! -n "$bonnie_docker_images" ] || [ "$rebuild" = "true" ]; then
        echo "Building Bonnie++ container"
        sh ./buildContainers.sh --bonnie
    fi
    currTimeStamp=$(date +%s)
    subFolderName="finalResults/Bonnie_${currTimeStamp}_${runtime}_${numParallelRuns}_${arr[1]}_${arr[2]}"
    mkdir $subFolderName
    logFile="${subFolderName}/Bonnie_RunLog.txt"
    arr+=($subFolderName $logFile)
    touch $logFile
    echo "ParallelBranch,StartTime,EndTime" > $logFile
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_bonnie $arr $x &
        PID="$!"
        PID_LIST+="$PID "
        x=$(($x + 1))
    done
    wait
    # cp "bonnie/mergeMergedCSV.py" "${subFolderName}/mergeMergedCSV.py"
    # cd $subFolderName
    # python3 mergeMergedCSV.py
    # cd ../..
}

run_cachebench() {
    # Cachebench Benchmark
    echo "Running Cachebench benchmark"
    # Check if Cachebench container image exists or if rebuild is requested
    cachebench_docker_images=$(sudo docker images | grep -E '.*(capstone_cachebench)+.*' | awk '{print $1}')
    if [ ! -n "$cachebench_docker_images" ] || [ "$1" = "true" ]; then
        sh ./buildContainers.sh --cachebench
    fi
    # At this point the container image should exist so we simply run the benchmark
    sudo docker run --rm capstone_cachebench
    # Extract report files from container
    running_llcbench_container=$(sudo docker ps -a | grep -E '.*(capstone_cachebench+)+.*' | awk '{print $1}')
    for container_id in $running_llcbench_container; do
        sudo docker cp "$container_id:/llcbench/llcbench/results ./llcbench/resultsFromDocker/"
    done
}

if [ "$#" = "0" ]; then
    help_menu
    exit
fi

clean
rebuild="false"
runtime="runc"

while getopts ":ert:l:n:s:c:u:y:b:" option
do
    case $option in
    e)
        echo "Cleaning container images and instances"
        sh ./buildContainers.sh --clean
        exit
        ;;
    r)
        rebuild="true";
        echo "Forced rebuild enabled"
        ;;
    t)
        runtime="$OPTARG"
        echo "Runtime changed to: $runtime"
        ;;
    l)
        numRuns="$OPTARG"
        arr=($numRuns $rebuild $runtime)
        run_linpack_parallel "$arr"
        ;;
    n)
        numRuns="$OPTARG"
        arr=($numRuns $rebuild $runtime)
        run_noploop_parallel "$arr"
        ;;
    u)
        numRuns="$OPTARG"
        arr=($numRuns $rebuild $runtime)
        run_unixbench_parallel "$arr"
        ;;
    s)
        numRuns="$OPTARG"
        arr=($numRuns $rebuild $runtime)
        run_sysbench_parallel "$arr"
        ;;
    y)
        numRuns="$OPTARG"
        arr=($numRuns $rebuild $runtime)
        run_ycruncher_parallel "$arr"
        ;;
    b)
        numRuns="$OPTARG"
        arr=($numRuns $rebuild $runtime)
        run_bonnie_parallel "$arr"
        ;;
    c)
        numRuns="$OPTARG"
        x=1
        while [ $x -le numRuns ]; do
            echo "Running iteration: $x"
            run_cachebench "$rebuild"
            if [ "$x" = "1" ]; then
                rebuild="false"
                exit
            fi
            x=$(($x + 1))
        done
        ;;
    *)
        echo "Unsupported option passed: $option"
        help_menu
        ;;
    esac
done

clean

echo "---------- Displaying active Docker containers ----------"
sudo docker ps -a
