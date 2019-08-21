#!/bin/sh

set -e

if [ -z "${APPLICATION_CREDENTIALS-}" ]; then
   echo "APPLICATION_CREDENTIALS not found. Exiting...."
   exit 1
fi

if [ -z "${PROJECT_ID-}" ]; then
   echo "PROJECT_ID not found. Exiting...."
   exit 1
fi

echo "$APPLICATION_CREDENTIALS" | base64 -d > /tmp/account.json

gcloud auth activate-service-account --key-file=/tmp/account.json
gcloud config set project "$PROJECT_ID"

sh -c "gcloud $*"