# Bentoml 사용법
참고. [어쩐지 오늘은-BentoML Basic](https://zzsza.github.io/mlops/2021/04/18/bentoml-basic/)

## 1. 모델 저장
- iris_classifier.py 로 Prediction service class 생성<BR>(class 이름을 바꾸면 바꾼 이름으로 저장됨.)
- python main.py 를 통해 학습 및 모델을 저장 만듦.
- $BENTOML_HOME 에 저장됨.(default=='~/bentoml')
- ~/bentoml/repository 에 학습한 모델 정보가 저장됨.

## 2. Local serving
- 다음을 입력하면 바로 serving 이 가능해짐.
```
bentoml serve IrisClassifier:latest
```
- localhost:5000 으로 접근하면 swagger UI 확인 가능.
- Prediction Request 는 다음 코드로 가능
```
curl -i \
  --header "Content-Type: application/json" \
  --request POST \
  --data '[[5.1, 3.5, 1.4, 0.2]]' \
  http://localhost:50051/predict
```
- 200 OK 로 결과가 뜨는 것 확인 가능.
## 3. Docker 실행
- 아래의 코드로 도커 실행 가능
```
docker run \
-v /var/run/docker.sock:/var/run/docker.sock \
-v ~/bentoml:/bentoml \
-p 3000:3000 \
-p 50051:50051 \
bentoml/yatai-service:latest
```
- 저장된 IrisClassifier 이름을 확인해서 Push 해주어 모델을 올림.
```
sudo bentoml push IrisClassifier:{repository에 있는 ID} --yatai-url=127.0.0.1:50051
```
- localhost:3000 에 접근해서 저장된 모델 확인 가능.
- 모델 API 서버 컨테이너화
```
bentoml containerize IrisClassifier:latest -t iris-classifier
```
- 완료 후 docker images 로 저장된 이미지를 확인 가능.
