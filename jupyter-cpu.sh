#!/usr/bin/bash

# Change this to your own advisor's faculty ID, used for storage. This is not a parameter
facultyId="chien-ju.ho" 

# Change this to your own Docker Repo ID. You can also edit with the -d tag
docker="saumikn/quickstart" 

# How many hours your job runs for. You can edit this with the -t tag. Max of 672 hour for any job
timeLimit="168"

# If you're launching multiple Jupyter Lab instances, use the -p parameter to change the port for each one, so they don't collide.
# Especially if your environments crash with the error "Bind for 0.0.0.0:8401 failed: port is already allocated"
port="8401"

# If you need multiple CPUs, use the -c parameter to add more CPUs
cores="1" 

# If you need more RAM, use the -m parameter to use more RAM
memory="16GB" 

while [ $# -gt 0 ]; do
  case "$1" in
    -p)
      port="$2"
      ;;
    -c)
      cores="$2"
      ;;
    -m)
      memory="$2"
      ;;
    -d)
      docker="$2"
      ;;
    -t)
      timeLimit="$2"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
  shift
done

LSF_DOCKER_VOLUMES="/scratch1/fs1/$facultyId:/scratch1/fs1/$facultyId /storage1/fs1/$facultyId/Active:/storage1/fs1/$facultyId/Active" LSF_DOCKER_PORTS="$port:$port" PATH="/opt/conda/bin:/usr/local/cuda/bin:$PATH" bsub -q general -n $cores -M $memory -R "select[port$port=1] span[hosts=1] rusage[mem=$memory]" -G compute-$facultyId -J "jupyter-cpu-$docker" -a "docker($docker)" -W ${timeLimit}:00 jupyter lab --allow-root --ip=0.0.0.0 --port $port --no-browser