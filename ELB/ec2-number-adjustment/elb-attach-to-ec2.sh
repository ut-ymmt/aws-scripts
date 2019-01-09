#!/bin/bash
## AWS_PROFILE={hoge} ./elb-attach-to-ec2.sh {LB_NAME} {NUM}
set -e

LB_NAME=$1
NUM=$2

cp deregister.json register.json
registered_list=$(cat register.json | jq -r ".[:$NUM]")
echo "###### $LB_NAME attach ec2 list ######"
echo "$registered_list" | jq '.[].InstanceId'
echo "count: $(echo "$registered_list" | jq '.[].InstanceId' | wc -l)"
echo '########################################'

read -p "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac

aws elb register-instances-with-load-balancer --load-balancer-name ${LB_NAME} --instances "$registered_list"
cat register.json | jq ".[$NUM:]" > deregister.json
