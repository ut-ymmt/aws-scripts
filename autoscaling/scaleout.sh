#!/bin/bash

set -e

ASG_NAME=$1
LB_NAME=$2

MIN_INSTANCES=1
MAX_INSTANCES=2
DESIRED_CAPACITY=2


echo "min: ${MIN_INSTANCES}, max: ${MAX_INSTANCES}, desired: ${DESIRED_CAPACITY}"
aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name $ASG_NAME \
  --min-size $MIN_INSTANCES \
  --max-size $MAX_INSTANCES \
  --desired-capacity $DESIRED_CAPACITY

target_instances=$(aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-name $ASG_NAME \
  --query 'AutoScalingGroups[].Instances[].{InstanceId: InstanceId}')

wait_condition=$DESIRED_CAPACITY
current_instances=0
max_trials=60
interval_sec=10 # timeout = max_trials * interval_sec
current_trials=0

echo "ELBのリスナーがdesired_capacityを満たすまで待機(max_retry: ${max_trials})"
while [ $wait_condition -gt $current_instances -a $max_trials -gt $current_trials ]
do
  current_instances=$(aws --profile jpstore elb describe-instance-health \
    --load-balancer-name $LB_NAME \
    --query "length(InstanceStates[?State=='InService'])")
  current_trials=$((${current_trials}+1))
  echo "number_of_trials: ${current_trials}, instances: ${current_instances}"
  sleep $interval_sec
done

echo 'スケールアウト完了'
