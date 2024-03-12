#!/usr/bin/bash

port="8228"
cores="8"
memory="100GB"
gpus="1"
model="TeslaV100_SXM2_32GB"
# model="NVIDIAA40"
docker="saumikn/chesstrainer"
tag="empty"
exclusive="no"
select="gpuhost,"
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
    -g)
      gpus="$2"
      select="gpuhost,"
      ;;
    -d)
      docker="$2"
      ;;
    -t)
      tag="$2"
      ;;
    -x)
      exclusive="$2"
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

echo "$select$port"

LSF_DOCKER_VOLUMES="/scratch1/fs1/chien-ju.ho:/scratch1/fs1/chien-ju.ho /storage1/fs1/chien-ju.ho/Active:/storage1/fs1/chien-ju.ho/Active" LSF_DOCKER_PORTS="$port:$port" PATH="/opt/conda/bin:/usr/local/cuda/bin:$PATH" bsub -q general -n $cores -M $memory -R "select[${select}port$port=1] span[hosts=1] rusage[mem=$memory]" -G compute-chien-ju.ho -J "jupyter-gpu-$tag" -gpu "num=$gpus:gmodel=$model:j_exclusive=$exclusive" -a "docker($docker:$tag)" jupyter lab --allow-root --ip=0.0.0.0 --port $port --no-browser
