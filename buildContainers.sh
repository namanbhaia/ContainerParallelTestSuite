#!bin/bash

## File to build all benchmark containers
# Help Menu
help_menu() {
    echo "Help Menu: "
    echo "Use the following options with buildContainers script:"
    echo "-clean or -c to remove all images/instances and exit"
    echo "-linpack or -lp to build linpack benchmark"
    echo "-noploop or -np to build noploop benchmark"
    echo "-cachebench or -cb to build cachebench benchmark"
    exit
}

clean() {
    # Removing docker images
    echo "---------- Removing Docker images ----------"
        
    active_docker_images=`sudo docker images | grep -E '.*(capstone+)+.*' | awk '{print $3}'`
    for docker_image in $active_docker_images
    do
        sudo docker rmi $docker_image
    done

    sysbench_docker_image=`sudo docker images | grep -E '.*(ljishen/sysbench+)+.*' | awk '{print $3}'`
    if [ -n "$active_docker_images" ]
    then
        sudo docker rmi $sysbench_docker_image
    fi
    
    dangling_docker_image=`sudo docker images -f "dangling=true" -q`
    for docker_image in $dangling_docker_image
    do
        sudo docker rmi $docker_image
    done
    
    # echo "---------- Displaying all Docker images after cleanup ----------"
    # sudo docker images
}

while [ ! -z "$1" ]; do
  case "$1" in
     --clean|-c)
         shift
         clean 
	     exit
         ;;
     --linpack|-lp)
	     # Linpack Benchmark
        shift
        echo "---------- Building Linpack container ----------"
		cd linpack
		sudo docker build -t capstone_linpack ./
		cd ..
         ;;
      --noploop|-np)
	     # Noploop Benchmark
        shift
        echo "---------- Building Noploop container ----------"
		cd noploop
		sudo docker build -t capstone_noploop ./
		cd ..
         ;;
      --cachebench|-cb)
	    # Cachebench Benchmark
        shift
        echo "---------- Building llcbench (Cachebench) container ----------"
		cd llcbench
		sudo docker build -t capstone_cachebench ./
		cd ..
         ;;
      --unixbench|-ub)
	    # Unixbench Benchmark
        shift
        echo "---------- Building Unixbench container ----------"
		cd unixbench
		sudo docker build -t capstone_unixbench ./
		cd ..
         ;;
     --ycruncher|-yc)
	    # Y-Cruncher Benchmark
        shift
        echo "---------- Building Y-cruncher container ----------"
		cd ycruncher
		sudo docker build -t capstone_ycruncher ./
		cd ..
         ;;
    --bonnie|-bo)
	    # Bonnie++ Benchmark
        shift
        echo "---------- Building Bonnie++ container ----------"
		cd bonnie
		sudo docker build -t capstone_bonnie ./
		cd ..
         ;;
     *)
        help_menu
        ;;
  esac
shift $(( $# > 0 ? 1 : 0 ))
done

# echo "---------- Displaying all Docker images ----------"
# sudo docker images
