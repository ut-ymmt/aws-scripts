#!/bin/bash
# 雑にroute53のレコードを列挙する

readonly HOSTED_ZONE_LIST=$(aws route53 list-hosted-zones | jq -r '.HostedZones[].Id')

echo -n $HOSTED_ZONE_LIST | tr '\ ' '\n' | xargs -I{} aws route53 list-resource-record-sets --hosted-zone-id {} | jq -c '.ResourceRecordSets[]'
