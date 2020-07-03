#!/bin/bash

set -e

if [[ $# -eq 0 ]] ; then
    echo 'Please provide the arn of the role you wish to assume as an argument'
    exit 1
fi
ASSUME_ROLE_ARN=$1
BUILD_ID=${2:-"test-session"}
echo "role-session-name will be: $BUILD_ID"

echo 'testing current credentials...'
aws sts get-caller-identity > /dev/null
echo 'Success'

echo "Trying to assume role: $ASSUME_ROLE_ARN ..."
CREDS=$(aws sts assume-role \
                          --role-arn "$ASSUME_ROLE_ARN" \
                          --role-session-name "$BUILD_ID" \
                          --duration-seconds 3600 \
                          --output json)
echo 'Success'

CRED_FILE_NAME="credentials.sh"
echo "export AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r ".Credentials.AccessKeyId")" > $CRED_FILE_NAME
echo "export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r ".Credentials.SecretAccessKey")" >> $CRED_FILE_NAME
echo "export AWS_SECURITY_TOKEN=$(echo $CREDS | jq -r ".Credentials.SessionToken")" >> $CRED_FILE_NAME
echo "export AWS_SESSION_TOKEN=$(echo $CREDS | jq -r ".Credentials.SessionToken")"  >> $CRED_FILE_NAME
echo "Credentials exported to $CRED_FILE_NAME. Your should now run source $CRED_FILE_NAME"

#echo "$AWS_ACCESS_KEY_ID"
#echo "$AWS_SECRET_ACCESS_KEY"
#echo "$AWS_SECURITY_TOKEN"
#echo "$AWS_SESSION_TOKEN"
