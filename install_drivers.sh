#!/bin/bash

# Verify if GPU is CUDA-enabled
# Run lspci | grep -i nvidia
lspci_output=$(lspci | grep -i nvidia)

# Check the return code of the previous command
if [ $? -eq 1 ]; then
    echo "No NVIDIA devices found."
    exit 1
fi

echo "NVIDIA devices found:"
echo "$lspci_output"

# Remove previous NVIDIA driver installation
sudo apt-get -y purge nvidia*
sudo apt -y remove nvidia-*
sudo rm /etc/apt/sources.list.d/cuda*
sudo apt-get autoremove -y && sudo apt-get -y autoclean
sudo rm -rf /usr/local/cuda*

# System update
sudo apt-get update -y
sudo apt-get upgrade -y

# Install essential packages
sudo apt-get install -y g++ freeglut3-dev build-essential libx11-dev
sudo apt-get install -y libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev

# Add PPA repository for NVIDIA drivers
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update -y

# Download and set up CUDA repository
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update -y

# Install CUDA Toolkit 12.3
sudo apt-get install -y cuda-toolkit-12-3

# Install NVIDIA driver and dependencies
sudo apt-get install -y nvidia-kernel-open-545

# Install CUDA Driver
sudo apt-get install -y cuda-drivers-545

# Set up paths for CUDA
echo 'export PATH=/usr/local/cuda-12.3/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.3/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
sudo ldconfig

# Install cuDNN v12.3
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update -y
sudo apt-get install -y cudnn-cuda-12

# Install nvtop for monitoring
sudo apt-get install -y nvtop

# Verify the installation
nvidia-smi
nvcc -V

# Clean up downloaded files
rm ./cuda-keyring_1.1-1_all.de*
