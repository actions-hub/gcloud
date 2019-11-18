#!/bin/sh

set -e

if [ ! -d "$HOME/.config/gcloud" ]; then
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
fi

echo ::add-path::/google-cloud-sdk/bin/gcloud
echo ::add-path::/google-cloud-sdk/bin/gsutil

command="gcloud"
if [ "$CLI" == "gsutil" ]; then
   command=$CLI
fi

if [[ ! $# -eq 0 ]] ; then
    sh -c "$command $*"
fi
