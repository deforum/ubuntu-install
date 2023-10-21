# Install and Set Up Guide

Follow this guide to setup a system with GPU drivers, CUDA toolkit, NVIDIA cuDNN, Miniconda, Docker and NVIDIA Container Toolkit.

## 1. GPU Drivers

We recommend using drivers from NVIDIA, which may be more reliable than using Additional Drivers App.

Download drivers from this [link](https://www.nvidia.com/download/driverResults.aspx/211711/en-us/) then reboot your system using `sudo reboot`.

Verify your GPU driver installation using:

```bash
nvidia-smi
```

## 2. Cuda Toolkit 12-3 deb (local)

Install the CUDA toolkit system wide from [here](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#), and download it from this [link](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=20.04&target_type=deb_local).

Then run the following commands:

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.3.0/local_installers/cuda-repo-ubuntu2004-12-3-local_12.3.0-545.23.06-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-12-3-local_12.3.0-545.23.06-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-3
```

After installation, ensure to add cuda paths to profile as shown [here](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions)

```bash
export PATH=/usr/local/cuda-12.2/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64\
                         ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

Reboot the system using `sudo reboot` and verify the install with `nvcc --version`.

## 3. NVIDIA cuDNN

Download NVIDIA cuDNN from the following links ([link1](https://developer.nvidia.com/cudnn), [link2](https://developer.nvidia.com/rdp/cudnn-download)).

Install guide can be found [here](https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html). Refer to Debian Local Installation section.

## 4. Miniconda

Download Miniconda:

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

... and install it:

```bash
bash Miniconda3-latest-Linux-x86_64.sh
```

## 5. Docker

Refer to Docker install guide [here](https://docs.docker.com/engine/install/ubuntu/).

Run the following commands to install Docker:

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

To finalize the instalation:

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

To verify the installation:

```bash
sudo docker run hello-world
```

Do not forget to perform the [post install steps](https://docs.docker.com/engine/install/linux-postinstall/):

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```

Log out or reboot and verify the installation by running:

```bash
docker run hello-world
```

## 6. Installing the NVIDIA Container Toolkit 

Follow the install guide [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

Run the following commands:

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
  && \
    sudo apt-get update
```

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
```

and 

```bash
docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
```

You may need to remove  "--runtime=nvidia" option.
