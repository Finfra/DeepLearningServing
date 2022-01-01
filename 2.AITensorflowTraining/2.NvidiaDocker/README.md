# Nvidia Docker
## Docker가 GPU자원을 쓸 수 있게 해줌
## Docker 를 설치하고 나면 기본적으로 컨테이너에서 원하는 작업을 수행 할 수 있게 된다. 그러나 격리된
## 일반 컨테이너에서 GPU를 사용하는 AI/ML/DL 관련 작업을 하려고 하면 nvidia-smi 를 터미널에서 입력해도 GPU 자원을 사용할 수 없음.
## Nvidia Docker 설치 후 조금의 옵션을 추가하면 컨테이너에서 GPU를 사용할 수있음.
## Home : https://github.com/NVIDIA/nvidia-docker

# 설치
* Source : [2.AITensorflowTraining/2.NvidiaDocker/installNvidiaDocker.sh](installNvidiaDocker.sh)
```
. installNvidiaDocker.sh
```

# 활용 예
## GPU
```
docker run -it --rm --runtime=nvidia \
tensorflow/tensorflow:latest-gpu python
```
## Jupyter
```
docker run -it --rm --runtime=nvidia     \
-v $(realpath ~/notebooks):/tf/notebooks \
-p 8888:8888 -p 6006:6006                \
tensorflow/tensorflow:latest-jupyter
```
## GPU + Juupyter
```
docker run -it --rm --runtime=nvidia     \
-v $(realpath ~/notebooks):/tf/notebooks \
-p 8888:8888 -p 6006:6006                \
tensorflow/tensorflow:latest-gpu-jupyter
```
