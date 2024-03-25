# By default, I'm building my container based on the `nvidia/cuda:11.6.2-base-ubuntu20.04`
# container, published by NVIDIA. You can change this if you need something else.
FROM nvidia/cuda:11.6.2-base-ubuntu20.04

# Necessary for the Dockerfile to install Ubuntu software without hanging
ARG DEBIAN_FRONTEND=noninteractive

# Installing a set of useful Ubuntu terminal commands with the `apt-get install`.
# If you've changed your OS from Ubuntu, this command will likely be different.
RUN apt-get update --fix-missing \
  && apt-get install -y git vim wget curl openssh-server \
  && apt-get clean 

# Installing and setting up miniforge (i.e. Conda)
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O ~/miniforge.sh && \
  bash ~/miniforge.sh -b -p /opt/conda && \
  rm ~/miniforge.sh && \
  /opt/conda/bin/conda init

# Updating path variables to point to miniconda
ENV PATH=/opt/conda/bin:$PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/conda/lib/

# Creating a base conda environment, with the minimum number of packages necessary to run Jupyter
# If you prefer, you can choose to add all your required packages into this base environment by
# editing the `environment.yml` file in this folder. Otherwise, you can just just use the approach
# described in Task 6 of github.com/saumikn/RIS-quickstart
ADD docker-environment.yml /tmp/docker-environment.yml
RUN mamba env update -n base -f /tmp/docker-environment.yml