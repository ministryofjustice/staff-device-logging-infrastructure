#!/bin/bash

set -ex

# build lambda package
echo "$OST_KEY"    | base64 -d > moj.key
echo "$OST_CRT"    | base64 -d > moj.crt
echo "$OST_CA_CRT" | base64 -d > elk-ca.crt

./functionbeat -e -c ../functionbeat-config.yml test config
./functionbeat -e -c ../functionbeat-config.yml package
zip -u package-aws.zip moj.crt moj.key elk-ca.crt

# build templates
./functionbeat -e -c ../functionbeat-config.yml export "function pttp-$ENV-infra-cloudwatch" > "cf-$ENV-cloudwatch.json"
./functionbeat -e -c ../functionbeat-config.yml export "function pttp-$ENV-infra-sqs"        > "cf-$ENV-sqs.json"

CW_S3_KEY=$(cat cf-$ENV-cloudwatch.json | jq -r '.. |."S3Key"? | select(. != null)')
SQS_S3_KEY=$(cat cf-$ENV-sqs.json       | jq -r '.. |."S3Key"? | select(. != null)')

aws s3 cp --no-progress ./package-aws.zip "s3://pttp-$ENV-infra-functionbeat-artifacts/$CW_S3_KEY"
aws s3 cp --no-progress ./package-aws.zip "s3://pttp-$ENV-infra-functionbeat-artifacts/$SQS_S3_KEY"

# upload templates
aws cloudformation deploy \
          --stack-name "pttp-$ENV-infra-cloudwatch" \
          --template-file "./cf-$ENV-cloudwatch.json" \
          --no-fail-on-empty-changeset

aws cloudformation deploy \
          --stack-name "pttp-$ENV-infra-sqs" \
          --template-file "./cf-$ENV-sqs.json" \
          --no-fail-on-empty-changeset
