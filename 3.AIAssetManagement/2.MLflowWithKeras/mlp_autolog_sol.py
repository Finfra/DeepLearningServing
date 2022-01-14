# import
import numpy as np
from tensorflow import keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense

import mlflow.keras

mlflow.keras.autolog()

# DataSet load
from sklearn import datasets
iris = datasets.load_iris()
x=iris.data
y = keras.utils.to_categorical(iris.target, 3)

# Model Define
model = Sequential()
model.add(Dense(2, activation='relu', input_shape=(4,)))
model.add(Dense(3, activation='softmax'))
model.summary()

model.compile(loss='categorical_crossentropy',
              optimizer='adam',
              metrics=['accuracy'])
# Training
model.fit(x, y,
          batch_size=10,
          epochs=100,
          verbose=0
)
# Inference
score = model.evaluate(x, y, verbose=0)
print('Test loss:', score[0])
print('Test accuracy:', score[1])
