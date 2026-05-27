#!/bin/bash
# This script runs /start.sh in the background to start Jupyter/SSH services,
# then executes your application.
#
# Usage: Modify this file to add your own commands after services start.

# Start base image services (Jupyter/SSH) in background
/start.sh &

# Wait a moment for services to start
sleep 2

# Add your application commands here
echo "$GITHUB_SSH" > ~/.ssh/github_ssh && chmod 600 ~/.ssh/github_ssh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_ssh 
unset $GITHUB_SSH
cd /workspace
mkdir code
mkdir data
cd code
git clone -b preprocess_polars git@github.com:seanv507/FuxiCTR.git
git clone -b update_fuxictr_2310 git@github.com:seanv507/FCN.git
set -o xtrace
echo "Hello Sean"
uv pip install --system --break-system-packages -e FuxiCTR
#uv pip install --system --break-system-packages -e FCN
uv pip install --system --break-system-packages huggingface_hub wandb
hf download --repo-type dataset seanv507/Criteo --local-dir /workspace/data/Criteo
wandb login $wandb_key
# Wait for background processes
wait
