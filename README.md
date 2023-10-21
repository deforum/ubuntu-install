# Install and Set Up Guide

Follow this guide to setup a system with GPU drivers, CUDA toolkit, NVIDIA cuDNN, Miniconda, Docker and NVIDIA Container Toolkit.

## 1. GPU Drivers

We recommend using drivers from NVIDIA over the Additional Drivers App. You can download the drivers directly from NVIDIA using the link below:

[Drivers Link](https://www.nvidia.com/download/driverResults.aspx/211711/en-us/)

After downloading the driver, reboot your system using the command:

```bash
sudo reboot
```

Verify the GPU driver installation using:

```bash
nvidia-smi
```

## 2. Cuda Toolkit 12-3 deb (local)

Install the CUDA toolkit system wide. You can find the installation guide on the NVIDIA website:

[CUDA Installation Guide](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#)

The toolkit can be downloaded from the following link:

[CUDA Downloads](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=20.04&target_type=deb_local)

After downloading, run the following commands:

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.3.0/local_installers/cuda-repo-ubuntu2004-12-3-local_12.3.0-545.23.06-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-12-3-local_12.3.0-545.23.06-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-3
```

After installation, remember to add CUDA paths to your profile as shown in the Post-Installation Actions section of the CUDA Installation Guide:

```bash
export PATH=/usr/local/cuda-12.2/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

Reboot the system using `sudo reboot` and verify the installation with `nvcc --version`.

## 3. NVIDIA cuDNN

You need an NVIDIA account to download cuDNN. You can download it from the following links:

[NVIDIA cuDNN](https://developer.nvidia.com/cudnn)

[cuDNN Download](https://developer.nvidia.com/rdp/cudnn-download)

And find the Installation Guide here:

[Installation Guide](https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html)

Refer to the Debian Local Installation section in the guide.

## 4. Miniconda

To install Miniconda, start by downloading it via the command:

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

Install it using the command:

```bash
bash Miniconda3-latest-Linux-x86_64.sh
```

## 5. Docker

The Docker install guide can be found in the link below:

[Docker Install Guide](https://docs.docker.com/engine/install/ubuntu/)

Install Docker by running the following commands:

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

Add the Docker repository to the Apt sources and update:

```bash
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

To finalize the installation:

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

To verify the installation:

```bash
sudo docker run hello-world
```

Also, perform the post-install steps as indicated in the link below:

[Docker Post-Install Steps Guide](https://docs.docker.com/engine/install/linux-postinstall/)

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```

Then log out or reboot. Verify the installation by running:

```bash
docker run hello-world
```

## 6. Installing the NVIDIA Container Toolkit 

The NVIDIA Container Toolkit can be installed by following the guide mentioned in the link below:

[NVIDIA Container Toolkit Install Guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

First, run the following commands:

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
  && \
    sudo apt-get update
```

Next, install the toolkit:

```bash
sudo apt-get install -y nvidia-container-toolkit
```

Configure Docker:

```bash
sudo nvidia-ctk runtime configure --runtime=docker
```

Restart Docker:

```bash
sudo systemctl restart docker
```

Verify the installation:

```bash
sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
```

Remember that you might need to remove  "--runtime=nvidia" option.
