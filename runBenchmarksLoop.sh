#! /bin/bash

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
    if [ ! -n "$running_docker_containers" ]; then
        echo "---------- No Docker containers running! ----------"
    else
        echo "---------- Stopping Docker containers ----------"
        for container_id in $running_docker_containers; do
            sudo docker stop $container_id
            sudo docker rm $container_id
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
    x=1
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we simply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/finalResults -e LINPACK_ARRAY_SIZE=600 capstone_linpack "${arr[@]}"
        x=$(($x + 1))
    done
}

run_linpack_parallel() {
    echo "Running Linpack benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    # Check if Linpack container image exists or if rebuild is requested
    linpack_docker_images=$(sudo docker images | grep -E '.*(capstone_linpack)+.*' | awk '{print $1}')
    if [ ! -n "$linpack_docker_images" ] || [ "$rebuild" = "true" ]; then
        echo "Building Linpack container"
        sh ./buildContainers.sh --linpack
    fi
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_linpack $arr &
        PID="$!"
        PID_LIST+="$PID "
        x=$(($x + 1))
    done    
    wait
}

run_noploop() {
    # Noploop Benchmark
    x=1
    arr=$1
    numContainerInstances=${arr[1]}
    runtime=${arr[4]}
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we simply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/finalResults capstone_noploop "${arr[@]}"
        x=$(($x + 1))
    done    
}

run_noploop_parallel() {
    echo "Running Noploop benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    # Check if Noploop container image exists or if rebuild is requested
    noploop_docker_images=$(sudo docker images | grep -E '.*(capstone_noploop)+.*' | awk '{print $1}')
    if [ ! -n "$noploop_docker_images" ] || [ "$rebuild" = "true" ]; then
        echo "Building Noploop container"
        sh ./buildContainers.sh --noploop
    fi
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_noploop "$arr" &
        x=$(($x + 1))
    done
    wait
}

run_unixbench() {
    # Unixbench Benchmark
    x=1
    arr=$1
    numContainerInstances=${arr[1]}
    runtime=${arr[4]}
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we simply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/finalResults capstone_unixbench "${arr[@]}"
        x=$(($x + 1))
    done
}

run_unixbench_parallel() {
    echo "Running Unixbench benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    # Check if Unixbench container image exists or if rebuild is requested
    unixbench_docker_images=$(sudo docker images | grep -E '.*(capstone_unixbench)+.*' | awk '{print $1}')
    if [ ! -n "$unixbench_docker_images" ] || [ "$rebuild" = "true" ]; then
        echo "Building Unixbench container"
        sh ./buildContainers.sh --unixbench
    fi
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_unixbench "$arr" &
        x=$(($x + 1))
    done
    wait
}

run_sysbench() {
    # Sysbench Benchmark
    #TODO: Currently does not support running the benchmark n times in each container. This is because the container image is pulled from the internet
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    numContainerInstances=${arr[1]}
    numRunsInContainer=${arr[2]}
    runtime=${arr[4]}
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we simply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/root/results ljishen/sysbench /root/results/output_cpu.prof --test=cpu --cpu-max-prime=20000000 --num-threads=2 --max-requests=10 run
        mv finalResults/output_cpu.prof "finalResults/SysbenchRun_${runtime}_${numParallelRuns}_${numContainerInstances}_${numRunsInContainer}_${x}.prof"
        x=$(($x + 1))
    done
}

run_sysbench_parallel() {
    echo "Running Sysbench benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_sysbench "$arr" &
        x=$(($x + 1))
    done
    wait
}

run_ycruncher() {
    # Y-Cruncher Benchmark
    x=1
    arr=$1
    numContainerInstances=${arr[1]}
    runtime=${arr[4]}
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we simply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/finalResults capstone_ycruncher "${arr[@]}"
        x=$(($x + 1))
    done
}

run_ycruncher_parallel() {
    echo "Running Y-Cruncher benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    # Check if Y-Cruncher container image exists or if rebuild is requested
    ycruncher_docker_images=$(sudo docker images | grep -E '.*(capstone_ycruncher)+.*' | awk '{print $1}')
    if [ ! -n "$ycruncher_docker_images" ] || [ "$rebuild" = "true" ]; then
        echo "Building Y-Cruncher container"
        sh ./buildContainers.sh --ycruncher
    fi
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_ycruncher "$arr" &
        x=$(($x + 1))
    done
    wait
}

run_bonnie() {
    # Bonnie++ Benchmark
    x=1
    arr=$1
    numContainerInstances=${arr[1]}
    runtime=${arr[4]}
    while [ $x -le $numContainerInstances ]; do
        # echo "Running serial container: $x"
        # At this point the container image should exist so we simply run the benchmark
        sudo docker run --runtime=$runtime -v ./finalResults:/finalResults capstone_bonnie "${arr[@]}"
        x=$(($x + 1))
    done
}

run_bonnie_parallel() {
    echo "Running Bonnie++ benchmark"
    x=1
    arr=$1
    numParallelRuns=${arr[0]}
    rebuild=${arr[3]}
    # Check if Bonnie++ container image exists or if rebuild is requested
    bonnie_docker_images=$(sudo docker images | grep -E '.*(capstone_bonnie)+.*' | awk '{print $1}')
    if [ ! -n "$bonnie_docker_images" ] || [ "$rebuild" = "true" ]; then
        echo "Building Bonnie++ container"
        sh ./buildContainers.sh --bonnie
    fi
    while [ $x -le $numParallelRuns ]; do
        echo "Running in parallel branch: $x"
        run_bonnie "$arr" &
        x=$(($x + 1))
    done
    wait
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