# Info
#install by ubuntu-18.04.5-desktop-amd64.iso
# Manual Job
echo "--------------------------------------------------------------------------------"
echo "# Install Base App--------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
# apt install -y ssh
# Basic Install
apt update -y
apt upgrade -y
apt install -y net-tools ssh git vim tmux curl httpie tree
apt install -y language-pack-ko language-pack-ko-base
apt install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
# apt -y install vnc4server
# apt -y install xfce4 xfce4-goodies
# apt -y install tightvncserver
x=$(cat /etc/bash.bashrc | grep "alias ll")
if [ ${#x} -eq 0 ]; then
     echo "alias ll='ls -als'" >> /etc/bash.bashrc
fi


# # Security
#
# x=$(cat /etc/ssh/sshd_config|grep PasswordAuthentication yes)
# [ ${#x} -eq 0 ]&& echo "PasswordAuthentication no" >> /etc/ssh/sshd_config;systemctl restart ssh
# #
# x=$(cat /etc/bash.bashrc|grep EDITOR)
# [ ${#x} -eq 0]&& echo "export EDITOR=vi">/etc/bash.bashrc

# PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;31m\]G\[\033[00m\] \[\033[01;34m\]\w \[\033[01;30m\]#\[\033[m\] "

echo "--------------------------------------------------------------------------------"
echo "# Hostname Setting--------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
[ ! $(echo $1) ]&& echo "Usage : . install.sh {hostname}"
[   $(echo $1) ]&& hostnamectl set-hostname $1


echo "--------------------------------------------------------------------------------"
echo "# Docker Setting--------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
curl -s https://get.docker.com/ | sudo sh
groupadd docker
usermod -aG docker ubuntu
chown -R root:docker /var/run/docker.sock
chmod 777 /var/run/docker.sock


echo "--------------------------------------------------------------------------------"
echo "# Python Install--------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"

apt install -y python3.7
apt install -y python3-distutils
apt install -y python3.7-dev
cp /usr/lib/python3/dist-packages/apt_pkg.cpython-36m-x86_64-linux-gnu.so /usr/lib/python3/dist-packages/apt_pkg.so



curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
python3.7 /tmp/get-pip.py
### Python
rm -f /usr/bin/python
# rm -f /usr/bin/python3
ln -s /usr/bin/python3.7 /usr/bin/python
# ln -s /usr/bin/python3.7 /usr/bin/python3
# ln -s /usr/bin/pip3.7 /usr/bin/pip
python3.7 -m pip install --upgrade pip



#-pip python3-dev
pip3.7 install virtualenvwrapper
x=$(cat /etc/bash.bashrc |grep virtualenvwrapper)
if [ ${#x} -eq 0 ]; then
cat >> /etc/bash.bashrc <<EOF
VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.7
export WORKON_HOME=~/.virtualenvs
. /usr/local/bin/virtualenvwrapper.sh
EOF
fi

echo "--------------------------------------------------------------------------------"
echo "# AWS CLI Install--------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
python3 /tmp/get-pip.py
# python3 -m pip uninstall -y botocore
# python3 -m pip uninstall -y boto3
python3 -m pip install awscli==1.22.28

#apt remove -y awscli
apt install -y awscli

echo "--------------------------------------------------------------------------------"
echo "## Jupyter ---------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
pip3.7 install jupyter
pip3.7 install jupyterlab

pip3.7 uninstall -y nbconvert
pip3.7 install nbconvert==5.6.1

apt-get remove -y python-pexpect python3-pexpect
pip3.7  install --upgrade pexpect
echo "yes"|jupyter notebook --generate-config
pip3 install https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master
jupyter contrib nbextension install --user
pip3.7 install RISE
jupyter-nbextension install rise --py --sys-prefix
pip3.7 install pandas matplotlib seaborn pillow scipy
pip3.7 install cython numpy
pip3.7 install opencv-python
pip3.7 install boto3
#
# pwd=$(pwd)
#
#

#
# cd $pwd
. installTensorflow.sh
