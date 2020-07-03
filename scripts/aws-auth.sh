#!/bin/bash

set -eo pipefail

if [[ $# -eq 0 ]] ; then
    echo 'Please provide the arn of the role you wish to assume as an argument'
    exit 1
fi
ASSUME_ROLE_ARN=$1


echo 'testing current credentials...'
aws sts get-caller-identity > /dev/null
echo 'Success'

echo "Trying to assume role: $ASSUME_ROLE_ARN ..."
CREDS=$(aws sts assume-role \
                          --role-arn "$ASSUME_ROLE_ARN" \
                          --role-session-name "test-session" \
                          --duration-seconds 3600 \
                          --output json)
echo 'Success'

export AWS_ACCESS_KEY_ID="$(    echo $CREDS | jq -r ".Credentials.AccessKeyId")"
export AWS_SECRET_ACCESS_KEY="$(echo $CREDS | jq -r ".Credentials.SecretAccessKey")"
export AWS_SECURITY_TOKEN="$(   echo $CREDS | jq -r ".Credentials.SessionToken")"
export AWS_SESSION_TOKEN=$AWS_SECURITY_TOKEN
echo "Credentials exported. Your aws cmds will now run as the provided role"

#echo "$AWS_ACCESS_KEY_ID"
#echo "$AWS_SECRET_ACCESS_KEY"
#echo "$AWS_SECURITY_TOKEN"
#echo "$AWS_SESSION_TOKEN"
