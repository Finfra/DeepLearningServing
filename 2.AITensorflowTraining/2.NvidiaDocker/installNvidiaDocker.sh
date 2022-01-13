echo "--------------------------------------------------------------------------------"
echo "# Install Docker"
echo "--------------------------------------------------------------------------------"

# curl -s https://get.docker.com/ | sudo sh
#
#
groupadd docker
usermod -aG docker ubuntu
chown -R root:docker /var/run/docker.sock
chmod 777 /var/run/docker.sock
service docker restart
gpasswd -a ubuntu docker
#
#

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

apt-get update
apt-get install -y nvidia-docker2
sudo systemctl restart docker

echo "# Test Docker ---------------------------------------------------------------------"
su - ubuntu -c "docker run --rm --gpus all ubuntu:18.04 nvidia-smi"
echo "--------------------------------------------------------------------------------"
