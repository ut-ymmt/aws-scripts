#!/bin/bash
## AWS_PROFILE={hoge} ./elb-detach-to-ec2.sh {LB_NAME} {NUM}
set -e

LB_NAME=$1
NUM=$2

list=$(aws elb describe-load-balancers --load-balancer-name ${LB_NAME} | jq ".LoadBalancerDescriptions[].Instances")
deregistered_list=$(echo $list | jq -r ".[:$NUM]")
echo "###### ${LB_NAME} detach ec2 list ######"
echo "$deregistered_list" | jq '.[].InstanceId'
echo "count: $(echo "$deregistered_list" | jq '.[].InstanceId' | wc -l)"
echo '###################################################'

read -p "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac

aws elb deregister-instances-from-load-balancer --load-balancer-name ${LB_NAME} --instances "$deregistered_list"
echo $deregistered_list > tmp.json.bak
jq -s add tmp.json.bak deregister.json > merge.json.bak
mv merge.json.bak deregister.json
rm *.bak
