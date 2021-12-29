# Info
#install by ubuntu-18.04.5-desktop-amd64.iso
# Manual Job
# Install Base App

sudo apt install -y ssh

# Basic Install
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y net-tools ssh git vim tmux curl httpie
sudo apt install -y software-properties-common
# apt -y install vnc4server
# apt -y install xfce4 xfce4-goodies
# apt -y install tightvncserver


# # Security
#
x=$(cat /etc/ssh/sshd_config|grep PasswordAuthentication yes)
[ ${#x} -eq 0 ]&& echo "PasswordAuthentication no" >> /etc/ssh/sshd_config;systemctl restart ssh
#
x=$(cat /etc/bash.bashrc|grep EDITOR)
[ ${#x} -eq 0]&& echo "export EDITOR=vi">/etc/bash.bashrc

PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;31m\]G\[\033[00m\] \[\033[01;34m\]\w \[\033[01;30m\]#\[\033[m\] "

# Info
sudo hostnamectl set-hostname fg1

# Install
## Python
sudo apt install -y python3.7
#-pip python3-dev
sudo pip3 install virtualenvwrapper
x=$(cat ~/.bashrc |grep virtualenvwrapper)
if [ ${#x} -eq 0 ]; then

  cat >> ~/.bashrc <<EOF
VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=~/.virtualenvs
. /usr/local/bin/virtualenvwrapper.sh
EOF
fi
#### Jupyter
sudo pip3 install jupyter
sudo apt-get remove -y python-pexpect python3-pexpect
sudo pip3  install --upgrade pexpect
echo "yes"|jupyter notebook --generate-config
sudo pip3 install https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master
sudo jupyter contrib nbextension install --user
sudo python3.7 -m pip3 install RISE
sudo jupyter-nbextension install rise --py --sys-prefix
sudo python3.7 -m pip3 install pandas matplotlib seaborn pillow scipy
sudo python3.7 -m pip3 install cython numpy
sudo python3.7 -m pip3 install opencv-python

pwd=$(pwd)


### Python
ln -s /usr/bin/python3 /usr/bin/python
ln -s /usr/bin/pip3 /usr/bin/pip
python -m pip install --upgrade pip

cd $pwd
. VagrantInstall.sh
. installTensorflow.sh
