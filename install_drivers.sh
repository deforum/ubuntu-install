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

# Install Mambaforge https://github.com/conda-forge/miniforge
# mkdir $HOME/apps
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh -b -p $HOME/mambaforge

# Set up paths for Mamba
echo 'export PATH=$HOME/mambaforge/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Add conda initalise block to .bashrc
mamba init

# Don't activate base env in terminal sessions
conda config --set auto_activate_base false

# Clean mambaforge install script
rm ./Mambaforge-Linux-x86_64.sh

# Install Docker https://docs.docker.com/engine/install/ubuntu/
# Uninstall old versions
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Actually install docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker post install steps https://docs.docker.com/engine/install/linux-postinstall/
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

sudo systemctl restart docker

# Install NVIDIA Container Toolkit
wget https://nvidia.github.io/libnvidia-container/gpgkey
sudo gpg --dearmor ./gpgkey > ./temp-keyring.gpg
sudo mv ./gpgkey.gpg /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
sudo wget https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list -P /etc/apt/sources.list.d/
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

sudo nvidia-ctk runtime configure --runtime=docker

# Clean thios steps downloaded files
sudo rm gpgkey temp-keyring.gpg

#Echo relevant info at end

echo "Important info"
