# Info
## 1. AWS Setting Info.
|서버 용도          |Server Name|Instance Type|AMI                                                                   |Zone           |EBS |Security Gupoup  |
|---------------|-----------|-------------|----------------------------------------------------------------------|---------------|----|-----------------|
|Console/Serving|c1-{num)   |t2.micro     |Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - ami-0ed11f3863410c386|ap-northeast-2c|30G |GPU_SecurityGroup|
|GPU1           |g1-{num)   |g3s.xlarge   |Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - ami-0ed11f3863410c386|ap-northeast-2c|30G |GPU_SecurityGroup|
|GPU2           |g2-{num)   |g3s.xlarge   |Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - ami-0ed11f3863410c386|ap-northeast-2c|30G |GPU_SecurityGroup|

### Security Group Setting
|IP version|Type      |Protocol|Port range|Source   |Description     |
|----------|----------|--------|----------|---------|----------------|
|IPv4      |SSH       |TCP     |22        |0.0.0.0/0|SSH             |
|IPv4      |Custom TCP|TCP     |12345     |0.0.0.0/0|for Multi Worker|
|IPv4      |Custom TCP|TCP     |9988      |0.0.0.0/0|Jupyter         |
|IPv4      |Custom TCP|TCP     |6006      |0.0.0.0/0|TensorBoard     |
|IPv4      |Custom TCP|TCP     |23456     |0.0.0.0/0|for Multi Worker|
|IPv4      |Custom TCP|TCP     |8888      |0.0.0.0/0|Serving         |
|IPv4      |Custom TCP|TCP     |5000      |0.0.0.0/0|Serving         |

# 셋팅 절차
## 1. 유저의 Public Key 추가 (모든 서버)
```
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEApTyEAbAstO1lrnRMls7roNpi4s7WbKZqIhz9uIubs/sJGqwruRLsJC4VoVfgLVTXO5WWJ6xIQ0MXpz+Xdx2VliPyFDVMMg0H9MyNjFpN+xgd7HwKM5AxOLc2Z6iJGV4NmFIGdvldI8B7xPae1L3jQn7cdoBkF3MNWV31BcITLUgd5hwXTgQ4pHx+xEIq6pmoSkZMCAcTUr1eECWzyPGy3b35bjXONxysRmvu9eo69HhtqhSBBrAhmsO6ITOqoBorbFw7o5ZP5W5/YGM3zYiYgepl+Bd3GYKdJ7hAbiUPf7dRx3L3+64GDovrzBvLSZZAYdhRzWErcUZwcZS+7pmEwQ== imksk
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDgq+pHCxO9IbndGBIyRkAOSSlw4h4/z8diWGWc4ZcVrwY8M1z1bTH+kEj5qjJ6AEwc/iU6hZ9jDr0YQrcs4FM5UJnY7Jcs1GYIimr7ZltXVgAYbLqHu0CHnZgVjvqy3RZxgSrQ89BgNujyd6ws53uF4cUILb3zqooSgLO5NlHOSBqV2dyKpvCc+FVmlZyjTFkW/gBpc6QDs+w9votH8MtpM+FNug4rlxVo7bfcp7tQa9AzcbxMHojVEDwTdi22wgPQ/q48o6r0LFOxvZHngsdL63YIWqKyr2uaHkM2z20uYnnYBRzTct+ldZqjk5pPArP+as2bai07rzxm/WtiWt19 nowage">> ~/.ssh/authorized_keys
```

## 2. Root Loging가능하게 하기 및 Git 유저 셋팅 (모든 서버)
```
sudo -i
rm /root/.ssh/authorized_keys
cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/authorized_keys
git config --global user.name "Steve J. South(NamJungGu) "
git config --global user.email "nowage@gmail.com"
git config --global credential.helper get
git config --global credential.helper erase
git config --global credential.helper store
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=36000'
git config --global credential.helper store 
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
. install.sh g1     #. install.sh g2  #. install.sh c1
```

## 5. 설치후 확인
```
nvidia-smi
echo "import tensorflow as tf
print('Num GPUs Available: ', len(tf.config.experimental.list_physical_devices('GPU')))
"|python3.7
```

* 위 스크립트 파라메터 없이 실행해서 host명 지정 못했을때 아래 스크립트 실행
```
hostnamectl set-hostname g1 # g2, s1
```
