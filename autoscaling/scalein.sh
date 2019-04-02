#!/bin/bash

set -e

ASG_NAME=$1

MIN_INSTANCES=1
MAX_INSTANCES=1
DESIRED_CAPACITY=1


echo min: ${MIN_INSTANCES}, max: ${MAX_INSTANCES}, desired: ${DESIRED_CAPACITY}
aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name $ASG_NAME \
  --min-size $MIN_INSTANCES \
  --max-size $MAX_INSTANCES \
  --desired-capacity $DESIRED_CAPACITY

echo スケールイン完了
