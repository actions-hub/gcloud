#!/bin/sh

set -e

PREVIOUS_PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)

set_up_a_credentials() {
    if [ "$(echo "$APPLICATION_CREDENTIALS" | tr -d \\n)" = "$(echo "$APPLICATION_CREDENTIALS" | base64 -d | base64  | tr -d \\n)" ]; then
        echo "APPLICATION_CREDENTIALS is Base64 Encoded"
        echo "$APPLICATION_CREDENTIALS" | base64 -d > /tmp/account.json
    else
        echo "APPLICATION_CREDENTIALS is not Base64 Encoded"
        echo "$APPLICATION_CREDENTIALS" > /tmp/account.json
    fi

    gcloud auth activate-service-account --key-file=/tmp/account.json
}

if [ ! -d "$HOME/.config/gcloud" ]; then
    echo "Previous configuration not detected"

    if [ -z "${APPLICATION_CREDENTIALS-}" ]; then
        echo "APPLICATION_CREDENTIALS not found. Exiting...."
        exit 1
    else
        set_up_a_credentials
    fi
else
    echo "Detect credentials from previous session..."

    if [ -n "${APPLICATION_CREDENTIALS-}" ]; then
        echo "APPLICATION_CREDENTIALS found. Setting up a credentials...."
        set_up_a_credentials
    else
        echo "Using credentials from previous session..."
    fi
fi

if [ -z "${PREVIOUS_PROJECT_ID-}" ]; then
    echo "Previous project id not detected"

    if [ -z "${PROJECT_ID-}" ]; then
        echo "PROJECT_ID not found. Exiting...."
        exit 1
    else
        gcloud config set project "$PROJECT_ID"
    fi
else
    echo "Previous project id detected"

    if [ -n "${PROJECT_ID-}" ] && [ "$PREVIOUS_PROJECT_ID" != "$PROJECT_ID" ]; then
        echo "Project id from the previous session is not the same as in actual. Setting up new project id..."
        gcloud config set project "$PROJECT_ID"
    else
        echo "Using project id from previous session...."
    fi
fi

echo "/google-cloud-sdk/bin/gcloud" >> $GITHUB_PATH
echo "/google-cloud-sdk/bin/gsutil" >> $GITHUB_PATH

command="gcloud"
if [ "$CLI" = "gsutil" ] || [ "$INPUT_CLI" = "gsutil" ]; then
    command="gsutil"
fi

if [ "$CLI" = "kubectl" ] || [ "$INPUT_CLI" = "kubectl" ]; then
    gcloud components install kubectl
    echo "/google-cloud-sdk/bin/kubectl" >> $GITHUB_PATH
    command="kubectl"
fi

if [ ! $# -eq 0 ]; then
    sh -c "$command $*"
fi
