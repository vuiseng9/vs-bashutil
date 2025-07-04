#!/usr/bin/env bash

# This script assumes the setup is carried with lambda_cloud_instance_setup.sh
# meant to be sourced in a conda environment 
# please cd to where you want to set up vllm and activate the conda environment first

# Install vllm
git clone https://github.com/vllm-project/vllm.git
cd vllm
git checkout v0.9.1 -b v0.9.1
VLLM_USE_PRECOMPILED=1 pip install --editable .
pip install pandas datasets matplotlib # needed for benchmarking samples
