#!/bin/bash

#################################################################
echo "--------------------------------------------------------------------------------"
echo "# Cuda Install -----------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
dpkg --configure -a
sudo apt -y purge nvidia-\*

sudo apt -y autoremove
sudo apt -y autoclean
sudo rm -rf /usr/local/cuda*

echo "--------------------------------------------------------------------------------"
#   https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#pre-installation-actions
add-apt-repository ppa:graphics-drivers/ppa -y
echo "***************Adding CUDA rep Key***************"
apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
echo "***************Adding CUDA repo to sources.list***************"
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" | tee /etc/apt/sources.list.d/cuda.list
echo "***************Downloading CUDA repo***************"
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-11-2_11.2.2-1_amd64.deb -O /tmp/cuda-11-2_11.2.2-1_amd64.deb
echo "***************Installing CUDA repo***************"

echo "Y"|apt install -y /tmp/cuda-11-2_11.2.2-1_amd64.deb
# echo "***************Updating***************"
# apt update -y
echo "***************Downloading machine learning repo***************"
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb -O /tmp/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
echo "***************Installing machine learning repo***************"
apt install -y /tmp/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb

echo "***************Installing Nvidia Driver***************"
sudo apt install -y nvidia-driver-495

apt-get install -y --no-install-recommends \
    cuda-11-2 \
    libcudnn8  \
    libcudnn8-dev

echo "--------------------------------------------------------------------------------"

# Setup CUDA paths
echo "***************Setting CUDA paths***************"
[ ! $(cat /etc/bash.bashrc|grep /usr/local/cuda-11.2/bin)   ]&& echo 'export PATH=/usr/local/cuda-11.2/bin:$PATH' >> /etc/bash.bashrc
[ ! $(cat /etc/bash.bashrc|grep /usr/local/cuda-11.2/lib64) ]&& echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64:$LD_LIBRARY_PATH' >> /etc/bash.bashrc
source /etc/bash.bashrc

echo "***************Running ldconfig***************"
ldconfig


echo "--------------------------------------------------------------------------------"
echo "# Tensorflow Install------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"

pip3.7 install --user tensorflow-gpu==2.7.0


echo "--------------------------------------------------------------------------------"
echo "# Tensorflow Gpu Test-----------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
nvidia-smi

echo "Numa Setting--------------------------------------------------------------------"
for i in $(lspci | grep -i nvidia|grep VGA|awk '{print $1}'); do
    f="/sys/bus/pci/devices/0000:$i/numa_node"
    [[ $(cat $f ) -eq -1 ]] && echo 0 > $f
done
echo "Cpu Count -----------------------------------------------------------------------"
echo "from tensorflow.python.client import device_lib
device_lib.list_local_devices()"|python3.7

echo "--------------------------------------------------------------------------------"

#
# OLD method
#
# # prg folder
# [ ! -d /root/prgs ] && mkdir /root/prgs
# export prgs_path=/root/prgs
# pwd=$(pwd)
#
# # add this to .bashrc
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64
#
# # Add NVIDIA package repositories
# cd $prgs_path
# export cuda_file_name=cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
# [ ! -f $cuda_file_name ] && wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/$cuda_file_name
#
# sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
# sudo dpkg -i $cuda_file_name
# sudo apt -y update
#
# export nvidia_repo_file_name=nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
# [ ! -f $nvidia_repo_file_name ] && wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/$nvidia_repo_file_name
# sudo apt install ./$nvidia_repo_file_name
# sudo apt -y update
#
# # Install NVIDIA driver
# sudo apt -y install --no-install-recommends nvidia-driver-450
# # Reboot. Check that GPUs are visible using the command: nvidia-smi
#
# # Install development and runtime libraries (~4GB)
# sudo apt -y install --no-install-recommends \
#     cuda-10-1 \
#     libcudnn7=7.6.5.32-1+cuda10.1  \
#     libcudnn7-dev=7.6.5.32-1+cuda10.1
#
# cd $pwd
