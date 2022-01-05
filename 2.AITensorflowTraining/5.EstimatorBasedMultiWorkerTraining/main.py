import tensorflow as tf
from multiprocessing import util

import mnist

import os, json

tf.compat.v1.disable_eager_execution()

BUFFER_SIZE = 10000
BATCH_SIZE = 64
tf_config = json.loads(os.environ['TF_CONFIG'])
# tf_config = json.loads("{ 'cluster': { 'worker': ['g1:12345', 'g2:23456'] }, 'task': {'type': 'worker', 'index': 0} }")
num_epochs = 3
num_steps_per_epoch=70

# Checkpoint saving and restoring
def _is_chief(task_type, task_id, cluster_spec):
  return (task_type is None
          or task_type == 'chief'
          or (task_type == 'worker'
              and task_id == 0
              and 'chief' not in cluster_spec.as_dict()))

def _get_temp_dir(dirpath, task_id):
  base_dirpath = 'workertemp_' + str(task_id)
  temp_dir = os.path.join(dirpath, base_dirpath)
  tf.io.gfile.makedirs(temp_dir)
  return temp_dir

def write_filepath(filepath, task_type, task_id, cluster_spec):
  dirpath = os.path.dirname(filepath)
  base = os.path.basename(filepath)
  if not _is_chief(task_type, task_id, cluster_spec):
    dirpath = _get_temp_dir(dirpath, task_id)
  return os.path.join(dirpath, base)

checkpoint_dir = os.path.join(util.get_temp_dir(), 'ckpt')

# os.environ['TF_CONFIG'] = json.loads("{ 'cluster': { 'worker': ['g1:12345', 'g2:23456'] },'task': {'type': 'worker', 'index': 0} }")

strategy = tf.distribute.experimental.MultiWorkerMirroredStrategy()

config = tf.estimator.RunConfig(train_distribute=strategy)

classifier = tf.estimator.Estimator(
    model_fn=mnist.model_fn, model_dir='/tmp/multiworker', config=config)
tf.estimator.train_and_evaluate(
    classifier,
    train_spec=tf.estimator.TrainSpec(input_fn=cnn.input_fn),
    eval_spec=tf.estimator.EvalSpec(input_fn=cnn.input_fn)
)
