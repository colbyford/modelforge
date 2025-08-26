FROM pytorch/pytorch:2.7.1-cuda12.6-cudnn9-devel

## Change to bash shell
SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

## Set up working directory
RUN mkdir -p /software/
WORKDIR /software/

## Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

## Install uv
RUN python -m pip install uv

## Clone modelforge from git
RUN git clone https://github.com/RosettaCommons/modelforge.git

## Change working directory
WORKDIR /software/modelforge

## Install modelforge
RUN uv python install 3.12 \
  && uv venv --python 3.12 \
  && source .venv/bin/activate \
  && uv pip install -e .

## Automatically activate the virtual environment
RUN echo "source $PWD/.venv/bin/activate" >> /root/.bashrc