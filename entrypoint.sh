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

    # Check if string is $APPLICATION_CREDENTIALS is base64 encoded or not
    if [ "$APPLICATION_CREDENTIALS" = "$(echo $APPLICATION_CREDENTIALS | base64 --decode | base64)" ]; then
      echo "$APPLICATION_CREDENTIALS" | base64 -d > /tmp/account.json
    else
      echo "$APPLICATION_CREDENTIALS" > /tmp/account.json
    fi

    gcloud auth activate-service-account --key-file=/tmp/account.json
    gcloud config set project "$PROJECT_ID"

    echo ::add-path::/google-cloud-sdk/bin/gcloud
    echo ::add-path::/google-cloud-sdk/bin/gsutil
else
    echo "Using credentials from previous session..."
    previous_id=$(gcloud config list --format 'value(core.project)' 2>/dev/null)

    if [ ! -z "${PROJECT_ID-}" ] && [ "$previous_id" != "$PROJECT_ID" ]; then
        echo "Project id from the previous session is not the same as in this. Trying to set up new project id..."

        if [ -z "${PROJECT_ID-}" ]; then
            echo "PROJECT_ID not found. Exiting...."
            exit 1
        fi

        gcloud config set project "$PROJECT_ID"
    fi
fi

command="gcloud"
if [ "$CLI" == "gsutil" ] || [ "$INPUT_CLI" == "gsutil" ]; then
    command="gsutil"
fi

if [[ ! $# -eq 0 ]] ; then
    sh -c "$command $*"
fi
