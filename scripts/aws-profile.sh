#!/bin/bash

set -e

if [[ $# -eq 0 ]] ; then
    echo 'Please provide the arn of the role you wish to assume as an argument'
    exit 1
fi
ASSUME_ROLE_ARN=$1
PROFILE_NAME=$2
BUILD_ID=${3:-"test-session"}
echo "role-session-name will be: $BUILD_ID"

echo 'testing current credentials...'
aws sts get-caller-identity > /dev/null
echo 'Success'

echo 'testing we are allowed to assume the given role...'
aws sts assume-role --role-arn "$ASSUME_ROLE_ARN" --role-session-name "$BUILD_ID-setup-test" --duration-seconds 900 > /dev/null
echo 'Success'

echo "writing profile '$PROFILE_NAME' that will assume role: to $ASSUME_ROLE_ARN ..."

mkdir -p  ~/.aws
echo "[profile $PROFILE_NAME]" >> ~/.aws/config
echo "role_arn = $ASSUME_ROLE_ARN" >> ~/.aws/config
echo "session_name = $BUILD_ID" >> ~/.aws/config
echo "credential_source = EcsContainer" >> ~/.aws/config

