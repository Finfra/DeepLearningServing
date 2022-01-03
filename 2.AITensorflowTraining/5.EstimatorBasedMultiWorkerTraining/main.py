import tensorflow_datasets as tfds
import tensorflow as tf
from multiprocessing import util

import cnn

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


def input_fn(mode, input_context=None):
  datasets, info = tfds.load(name='mnist',
                                with_info=True,
                                as_supervised=True)
  mnist_dataset = (datasets['train'] if mode == tf.estimator.ModeKeys.TRAIN else
                   datasets['test'])

  def scale(image, label):
    image = tf.cast(image, tf.float32)
    image /= 255
    return image, label

  if input_context:
    mnist_dataset = mnist_dataset.shard(input_context.num_input_pipelines,
                                        input_context.input_pipeline_id)
  return mnist_dataset.map(scale).cache().shuffle(BUFFER_SIZE).batch(BATCH_SIZE)


# os.environ['TF_CONFIG'] = json.loads("{ 'cluster': { 'worker': ['g1:12345', 'g2:23456'] },'task': {'type': 'worker', 'index': 0} }")

strategy = tf.distribute.experimental.MultiWorkerMirroredStrategy()

config = tf.estimator.RunConfig(train_distribute=strategy)

classifier = tf.estimator.Estimator(
    model_fn=cnn.model_fn, model_dir='/tmp/multiworker', config=config)
tf.estimator.train_and_evaluate(
    classifier,
    train_spec=tf.estimator.TrainSpec(input_fn=input_fn),
    eval_spec=tf.estimator.EvalSpec(input_fn=input_fn)
)
