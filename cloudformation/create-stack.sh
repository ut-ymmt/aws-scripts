#!/bin/sh
set -eu
TEMPLATE=$1
STACK_NAME=$2
ENV=$3

echo `date '+[%y/%m/%d %H:%M:%S]'` スタックの作成を開始
aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://$TEMPLATE \
  --parameters `js-yaml properties/${ENV}.yml | jq -c 'to_entries | map({ParameterKey: .key, ParameterValue: .value | tostring})'` \
  --capabilities CAPABILITY_NAMED_IAM
echo `date '+[%y/%m/%d %H:%M:%S]'` スタックの作成完了を待機
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME
aws cloudformation describe-stacks --stack-name $STACK_NAME
aws cloudformation describe-stack-resources --stack-name $STACK_NAME
echo `date '+[%y/%m/%d %H:%M:%S]'` スタックの作成が完了
