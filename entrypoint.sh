#!/bin/sh

set -e


if [[ -z "$APPLICATION_CREDENTIALS" ] && [ -z "$INPUT_APPLICATION_CREDENTIALS" ]]
then
  echo "APPLICATION_CREDENTIALS not found. Exiting...."
  exit 1
fi

# This allows for backwards capability. The old way is setting the env, but this
# handles env not set use input.
if [ -z $APPLICATION_CREDENTIALS ]
then
  APPLICATION_CREDENTIALS=$INPUT_APPLICATION_CREDENTIALS
fi

# Credentials are provided so they will be used.
echo "$APPLICATION_CREDENTIALS" | base64 -d > /tmp/account.json
gcloud auth activate-service-account --key-file=/tmp/account.json

# Either the env.PROJECT_ID needs to be set or input.PROJECT_ID.
if [[ -z "$PROJECT_ID" ] && [ -z "$INPUT_PROJECT_ID" ]]
then
  echo "PROJECT_ID not found. Exiting...."
  exit 1
fi

# This allows for backwards compatible. The old way is setting the env, but this
# handles env not set use input.
if [ -z $PROJECT_ID ]
then
  PROJECT_ID=$INPUT_PROJECT_ID
fi

# Set the project id
gcloud config set project "$PROJECT_ID"

echo ::add-path::/google-cloud-sdk/bin/gcloud
echo ::add-path::/google-cloud-sdk/bin/gsutil

command="gcloud"
if [ "$CLI" == "gsutil" ]; then
   command=$CLI
fi

if [[ ! $# -eq 0 ]] ; then
    sh -c "$command $*"
fi
