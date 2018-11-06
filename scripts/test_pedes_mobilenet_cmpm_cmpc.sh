#!/bin/bash
#
GPU_ID=$1
export CUDA_VISIBLE_DEVICES=$1

# Where the dataset is saved to.
DATASET_DIR=/media/fuming/dl/CMPL/Cross-Modal-Projection-Learning/builddata/Dataset/TFRecords/pedes
RESTORE_PATH=/media/fuming/dl/CMPL/Cross-Modal-Projection-Learning/PreTrainedModels/mobilenet_v1

# Where the checkpoint and logs saved to.
DATASET_NAME=pedes
SAVE_NAME=pedes_mobilenet_cmpm_cmpc
CKPT_DIR=${SAVE_NAME}/dl/checkpoint
RESULT_DIR=${SAVE_NAME}/dl/results

MODEL_NAME=mobilenet_v1
MODEL_SCOPE=MobilenetV1

SPLIT_NAME=test

for i in $(seq 0 20)
do
    # Run evaluation.
    python test_image_text.py \
      --checkpoint_dir=${CKPT_DIR} \
      --eval_dir=${RESULT_DIR} \
      --dataset_name=${DATASET_NAME} \
      --split_name=${SPLIT_NAME} \
      --dataset_dir=${DATASET_DIR} \
      --model_name=${MODEL_NAME} \
      --model_scope=${MODEL_SCOPE} \
      --preprocessing_name=${MODEL_NAME} \
      --batch_size=1

    echo "Evaluating with Cosine Distance..."
    python2 evaluation/bidirectional_eval.py ${RESULT_DIR} --method cosine

    echo "Waiting..."
    sleep 20m

done
