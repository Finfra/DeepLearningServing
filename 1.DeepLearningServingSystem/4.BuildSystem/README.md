# Info
## 1. AWS Setting Info.
|서버 용도          |Server Name|Instance Type|AMI                                                                   |Zone           |EBS |Security Gupoup  |
|---------------|-----------|-------------|----------------------------------------------------------------------|---------------|----|-----------------|
|Console/Serving|c1-{num)   |t2.micro     |Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - ami-0ed11f3863410c386|ap-northeast-2c|30G |GPU_SecurityGroup|
|GPU1           |g1-{num)   |g3s.xlarge   |Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - ami-0ed11f3863410c386|ap-northeast-2c|30G |GPU_SecurityGroup|
|GPU2           |g2-{num)   |g3s.xlarge   |Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - ami-0ed11f3863410c386|ap-northeast-2c|30G |GPU_SecurityGroup|


# 셋팅 절차
## 1. 유저의 Public Key 추가 (모든 서버)
```
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEApTyEAbAstO1lrnRMls7roNpi4s7WbKZqIhz9uIubs/sJGqwruRLsJC4VoVfgLVTXO5WWJ6xIQ0MXpz+Xdx2VliPyFDVMMg0H9MyNjFpN+xgd7HwKM5AxOLc2Z6iJGV4NmFIGdvldI8B7xPae1L3jQn7cdoBkF3MNWV31BcITLUgd5hwXTgQ4pHx+xEIq6pmoSkZMCAcTUr1eECWzyPGy3b35bjXONxysRmvu9eo69HhtqhSBBrAhmsO6ITOqoBorbFw7o5ZP5W5/YGM3zYiYgepl+Bd3GYKdJ7hAbiUPf7dRx3L3+64GDovrzBvLSZZAYdhRzWErcUZwcZS+7pmEwQ== imksk">> ~/.ssh/authorized_keys
```

## 2. Root Loging가능하게 하기 및 Git 유저 셋팅 (모든 서버)
```
sudo -i
rm /root/.ssh/authorized_keys
cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/authorized_keys
git config --global user.name "Steve J. South(NamJungGu) "
git config --global user.email "nowage@gmail.com"
git config credential.helper get
git config credential.helper erase
git config credential.helper store
git config credential.helper cache
git config credential.helper 'cache --timeout=36000'
git config credential.helper store --global
git config --global core.autocrlf false
git config --global core.eol lf
git config --global color.status auto
git config --global color.branch auto
git config --list
```

## 3. git clone (모든 서버)
```
sudo -i
git clone https://github.com/Finfra/DeepLearningServing
```

## 4. Install Software
* 첫번째 파라메터가 hostname임.
```
sudo -i
cd /root/DeepLearningServing/1.DeepLearningServingSystem/4.BuildSystem/
. install.sh g1     #. install.sh g2  #. install.sh s1
```
