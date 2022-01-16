#!/bin/bash

tensorflow_model_server  \
	--port=9988             \
	--rest_api_port=8888     \
	--model_name=iris        \
	--model_base_path=/tmp/saved_model 
