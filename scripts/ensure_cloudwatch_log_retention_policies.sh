#!/bin/bash

log_group_names=$(aws logs describe-log-groups | jq -r '.logGroups | .[] | .logGroupName')

for log_group_name in $log_group_names
do
  aws logs delete-retention-policy --log-group-name $log_group_name
  aws logs put-retention-policy --log-group-name $log_group_name --retention-in-days 7
done
