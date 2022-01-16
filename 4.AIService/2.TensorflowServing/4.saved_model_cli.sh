#!/bin/bash

saved_model_cli run  --dir /tmp/saved_model/1/ \
--signature_def serving_default                      \
--tag_set=serve                                \
--input_expr "dense_input=[[1., 0., 0., 0.]]"
