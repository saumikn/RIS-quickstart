FROM nvidia/cuda:11.6.2-base-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing \
  && apt-get install -y wget curl bzip2 git vim build-essential \
                        ca-certificates libglib2.0-0 libxext6 \
                        libsm6 libxrender1 libstdc++6 python3-dev \
                        cmake libboost-all-dev \
                        nano sudo htop tmux unzip \
  && apt-get clean 

RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -O ~/mambaforge.sh && \
  bash ~/mambaforge.sh -b -p /opt/conda && \
  rm ~/mambaforge.sh && \
  /opt/conda/bin/conda init

ENV PATH=/opt/conda/bin:$PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/conda/lib/

ADD environment.yml /tmp/environment.yml
RUN mamba env update -n base -f /tmp/environment.yml