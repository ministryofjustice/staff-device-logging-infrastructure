#!/bin/bash

set -e -u -o -x pipefail

# create temporay role
TEMP_ROLE=`aws sts assume-role --role-arn $ROLE_ARN --role-session-name ci-build-$CODEBUILD_BUILD_NUMBER`
echo $TEMP_ROLE
export AWS_ACCESS_KEY_ID=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SessionToken')

# build lambdas
cd functionbeat
echo $OST_KEY    | base64 -d > moj.key
echo $OST_CRT    | base64 -d > moj.crt
echo $OST_CA_CRT | base64 -d > elk-ca.crt
./functionbeat -e -c ../functionbeat-config.yml test config
./functionbeat -e -c ../functionbeat-config.yml package
zip -u package-aws.zip moj.crt moj.key elk-ca.crt

# build templates
./functionbeat -e -c ../functionbeat-config.yml export function staff-device-$ENV-infra-cloudwatch-syslog > cf-$ENV-cloudwatch-syslog.json
./functionbeat -e -c ../functionbeat-config.yml export function staff-device-$ENV-infra-cloudwatch  > cf-$ENV-cloudwatch.json
./functionbeat -e -c ../functionbeat-config.yml export function staff-device-$ENV-infra-sqs         > cf-$ENV-sqs.json
./functionbeat -e -c ../functionbeat-config.yml export function staff-device-$ENV-infra-kinesis     > cf-$ENV-kinesis.json
./functionbeat -e -c ../functionbeat-config.yml export function staff-device-$ENV-infra-dlq > cf-$ENV-dlq.json

# upload lambdas
export CW_SYSLOG_S3_KEY=`cat cf-$ENV-cloudwatch-syslog.json | jq -r '.. |."S3Key"? | select(. != null)'`
export CW_S3_KEY=`cat cf-$ENV-cloudwatch.json | jq -r '.. |."S3Key"? | select(. != null)'`
export SQS_S3_KEY=`cat cf-$ENV-sqs.json       | jq -r '.. |."S3Key"? | select(. != null)'`
export KINESIS_S3_KEY=`cat cf-$ENV-kinesis.json | jq -r '.. |."S3Key"? | select(. != null)'`
export DLQ_SQS_S3_KEY=`cat cf-$ENV-dlq.json       | jq -r '.. |."S3Key"? | select(. != null)'`

aws s3 cp --no-progress ./package-aws.zip s3://staff-device-$ENV-infra-functionbeat-artifacts/$CW_SYSLOG_S3_KEY
aws s3 cp --no-progress ./package-aws.zip s3://staff-device-$ENV-infra-functionbeat-artifacts/$CW_S3_KEY
aws s3 cp --no-progress ./package-aws.zip s3://staff-device-$ENV-infra-functionbeat-artifacts/$SQS_S3_KEY
aws s3 cp --no-progress ./package-aws.zip s3://staff-device-$ENV-infra-functionbeat-artifacts/$KINESIS_S3_KEY
aws s3 cp --no-progress ./package-aws.zip s3://staff-device-$ENV-infra-functionbeat-artifacts/$DLQ_SQS_S3_KEY

aws cloudformation deploy \
  --stack-name staff-device-$ENV-infra-cloudwatch-syslog \
  --template-file ./cf-$ENV-cloudwatch-syslog.json \
  --no-fail-on-empty-changeset

aws cloudformation deploy \
  --stack-name staff-device-$ENV-infra-cloudwatch \
  --template-file ./cf-$ENV-cloudwatch.json \
  --no-fail-on-empty-changeset

aws cloudformation deploy \
  --stack-name staff-device-$ENV-infra-sqs \
  --template-file ./cf-$ENV-sqs.json \
  --no-fail-on-empty-changeset

aws cloudformation deploy \
  --stack-name staff-device-$ENV-infra-kinesis \
  --template-file ./cf-$ENV-kinesis.json \
  --no-fail-on-empty-changeset

aws cloudformation deploy \
  --stack-name staff-device-$ENV-infra-dlq \
  --template-file ./cf-$ENV-dlq.json \
  --no-fail-on-empty-changeset
