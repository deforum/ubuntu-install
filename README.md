# Install and Set Up Guide

Follow this guide to setup a system with GPU drivers, CUDA toolkit, NVIDIA cuDNN, Miniconda, Docker and NVIDIA Container Toolkit.

## THESE INSTRUCTIONS ARE FOR UBUNTU 22.04
The commands in this readme are for Ubuntu 22.04. You can follow similar steps for other Ubuntu versions however the commands will be slightly different. Instructions last updated Mar 3 2024.

## 1. GPU Drivers

You can install drivers through the Additional Drivers application in the Ubuntu menu.

Another option is to install drivers by executing the following commands in the terminal.
```bash
sudo apt install nvidia-driver-545
```

Once drivers are installed you will need to reboot the system.
```bash
sudo reboot
```

After you can verify the installation with the following commands:
```bash
nvidia-smi
```

You should see something that looks like this:
```bash
Thu Feb 29 07:07:23 2024       
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 545.23.08              Driver Version: 545.23.08    CUDA Version: 12.3     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA RTX A6000               On  | 00000000:0A:00.0  On |                  Off |
| 30%   30C    P8              26W / 300W |    441MiB / 49140MiB |      4%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
                                                                                         
+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A      1950      G   /usr/lib/xorg/Xorg                          212MiB |
|    0   N/A  N/A      2083      G   /usr/bin/gnome-shell                        146MiB |
+---------------------------------------------------------------------------------------+
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
export PATH=/usr/local/cuda-12.3/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-12.3/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

Reboot the system:
```bash
sudo reboot
```
and verify the installation with 
```bash
nvcc --version
```

## 3. NVIDIA cuDNN

You need an NVIDIA account to download cuDNN. You can download it from the following links:

[NVIDIA cuDNN](https://developer.nvidia.com/cudnn)

[cuDNN Download](https://developer.nvidia.com/rdp/cudnn-download)

And find the Installation Guide here:

[Installation Guide](https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html)

Refer to the Debian Local Installation section in the guide.

Or just do the following:
```bash
wget https://developer.download.nvidia.com/compute/cudnn/9.0.0/local_installers/cudnn-local-repo-ubuntu2204-9.0.0_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2204-9.0.0_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu2204-9.0.0/cudnn-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cudnn
```
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
