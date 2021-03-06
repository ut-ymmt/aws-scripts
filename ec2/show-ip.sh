#!/bin/bash

readonly AWS_ACCOUNT=$1
readonly EC2_NAME_TAG=$2
readonly KIND_OF_IP=$3
readonly INSTANCE_STATE=$4

if [ -z $KIND_OF_IP ]; then
  ip_type='PrivateIpAddress'
elif [ $KIND_OF_IP = 'private' ]; then
  ip_type='PrivateIpAddress'
elif [ $KIND_OF_IP = 'public' ]; then
  ip_type='PublicIpAddress'
else
  echo 'usage: show-ip [AWS_ACCOUNT_PROFILE] [EC2_NAME_TAG] [Option private or public]'
  exit 1
fi

if [ -z $AWS_ACCOUNT ]; then
  echo 'usage: show-ip [AWS_ACCOUNT_PROFILE] [EC2_NAME_TAG] [Option private or public]'
  exit 2
fi

if [ -z $INSTANCE_STATE ]; then
  state='running'
else
  state=$INSTANCE_STATE
fi

aws --profile $AWS_ACCOUNT ec2 describe-instances --filter "Name=tag:Name,Values=*$EC2_NAME_TAG*" | \
  jq -cr ".Reservations[].Instances[] \
  | select(.State.Name==\"$state\") \
  | .$ip_type"
