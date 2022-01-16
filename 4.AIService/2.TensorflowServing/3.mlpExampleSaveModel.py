import os
import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from sklearn.model_selection import train_test_split
from sklearn import datasets

version = 1
batch_size = 50
epochs = 100
num_classes = 3

iris = datasets.load_iris()
x=iris.data
y = keras.utils.to_categorical(iris.target, num_classes)
x_train, x_test, y_train, y_test = train_test_split(x, y)

model = Sequential()
model.add(Dense(6, activation='tanh', input_shape=(4,)))
model.add(Dense(5, activation='relu'))
model.add(Dense(3, activation='softmax'))
model.summary()
model.compile(loss='categorical_crossentropy',
              optimizer='adam',
              metrics=['accuracy'])



from tensorflow.keras.callbacks import ModelCheckpoint
filename = f'/tmp/checkpoint-epoch-{epochs}-batch-{batch_size}-trial-001.h5'
checkpoint = ModelCheckpoint(filename,
                             monitor='val_loss',
                             verbose=1,
                             save_best_only=True,
                             mode='auto'
                            )


history = model.fit(x_train, y_train,
                    batch_size=batch_size,
                    epochs=epochs,
                    verbose=1,
                    validation_data=(x_test, y_test))
score = model.evaluate(x_test, y_test, verbose=0)

print('Test loss:', score[0])
print('Test accuracy:', score[1])

# Predict
#model.predict(x_test)


# Model Save
def make_directory(target_path):
  if not os.path.exists(target_path):
    os.mkdir(target_path)
    print('Directory ', target_path, ' Created ')
  else:
    print('Directory ', target_path, ' already exists')

SAVED_MODEL_PATH = '/tmp/saved_model'
make_directory(SAVED_MODEL_PATH)
MODEL_DIR = SAVED_MODEL_PATH


export_path = os.path.join(MODEL_DIR, str(version))
print('export_path = {}\n'.format(export_path))

tf.keras.models.save_model(
  model,
  export_path,
  overwrite=True,
  include_optimizer=True,
  save_format=None,
  signatures=None,
  options=None
)
print('\nSaved model:')
