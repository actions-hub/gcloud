# gcloud

[![Preview](https://serhiy.s3.eu-central-1.amazonaws.com/Github_repo/gcloud/logo_gcp_vertical_rgb.png?v=1)](https://cloud.google.com)

GitHub Action which allows interacting with [Google Cloud Platform](https://cloud.google.com).

## Usage

To use gcloud in your workflow use:

```yaml
- uses: actions-hub/gcloud@master
  env:
    PROJECT_ID: test
    APPLICATION_CREDENTIALS: ${{ secrets.GOOGLE_APPLICATION_CREDENTIALS }}
  with:
    args: info
```

You can also use `gsutil` from Google Cloud SDK package.

```yaml
- uses: actions-hub/gcloud@master
  env:
    PROJECT_ID: test
    APPLICATION_CREDENTIALS: ${{ secrets.GOOGLE_APPLICATION_CREDENTIALS }}
  with:
    args: cp your-file.txt gs://your-bucket/
    cli: gsutil
```

You can also use `kubectl` from Google Cloud SDK package.

```yaml
- uses: actions-hub/gcloud@master
  env:
    PROJECT_ID: test
    APPLICATION_CREDENTIALS: ${{ secrets.GOOGLE_APPLICATION_CREDENTIALS }}
  with:
    args: create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
    cli: kubectl
```

### Secrets

`APPLICATION_CREDENTIALS` - To authorize in GCP you need to have a [service account key](https://console.cloud.google.com/apis/credentials/serviceaccountkey).
The recommended way to store the credentials in the secrets it previously encode file with base64. To encode a JSON file use: `base64 ~/<account_id>.json`. Or you can put a JSON structure to the secret.

`PROJECT_ID` - must be provided to activate a specific project.

### Using access tokens

Alternatively, you can set the environment variable `CLOUDSDK_AUTH_ACCESS_TOKEN` to a valid OAUTH token; this allows the step to be used with [Workload Identity Federation](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions).

```yaml
- id: google_cloud_auth
  name: Authenticate to Google Cloud
  uses: google-github-actions/auth@v1
  with:
    workload_identity_provider: 'projects/${{ secrets.gcp_project_number }}/locations/global/workloadIdentityPools/${{ secrets.workload_identity_pool }/providers/${{ secrets.workload_identity_provider }}'
    service_account: '${{ secrets.workload_identity_service_account }}@${{ secrets.gcp_project_name }}.iam.gserviceaccount.com'
    token_format: 'access_token'

- uses: actions-hub/gcloud@master
  env:
    PROJECT_ID: ${{ secrets.gcp_project_name }}
    CLOUDSDK_AUTH_ACCESS_TOKEN: '${{ steps.google_cloud_auth.outputs.access_token }}'
  with:
    args: info
```

Two important notes:

1. If `CLOUDSDK_AUTH_ACCESS_TOKEN` is set, it will override any other auth configuration
2. The `gsutil` command does not support the `CLOUDSDK_AUTH_ACCESS_TOKEN` variable; use [gcloud storage](https://cloud.google.com/sdk/gcloud/reference/storage) to interact with GCS.

### Inputs

`args` - command to run.

`cli` - (optional) command line tool you want to use. Defaults to `gcloud`, allowed values: `gcloud`, `gsutil`.

### Version
For each new release of gcloud master branch is updated to the latest version. Also, the tag is creating with the same number as the gcloud version. If you want to always have the latest version of gcloud, use `@master` branch. 
But if you need some specific version of gcloud just use a specific tag. For example `@271.0.0`.

## Example
### Latest version
```yaml
name: gcloud
on: [push]

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1
      - uses: actions-hub/gcloud@master
        env:
          PROJECT_ID: ${{secrets.GCLOUD_PROJECT_ID}}
          APPLICATION_CREDENTIALS: ${{secrets.GOOGLE_APPLICATION_CREDENTIALS}}
        with:
          args: app deploy app.yaml
```

### Multistep
```yaml
name: gcloud
on: [push]

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1

      - name: "deploy to project A"  
        uses: actions-hub/gcloud@master
        env:
          PROJECT_ID: ${{secrets.GCLOUD_PROJECT_ID_A}}
          APPLICATION_CREDENTIALS: ${{secrets.GOOGLE_APPLICATION_CREDENTIALS}}
        with:
          args: app deploy app.yaml
      
      - name: "deploy to project B"  
        uses: actions-hub/gcloud@master
        env:
          PROJECT_ID: ${{secrets.GCLOUD_PROJECT_ID_B}}
        with:
          args: app deploy app.yaml
```

### Specific version
```yaml
name: gcloud
on: [push]

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1
      - uses: actions-hub/gcloud@271.0.0
        env:
          PROJECT_ID: ${{secrets.GCLOUD_PROJECT_ID}}
          APPLICATION_CREDENTIALS: ${{secrets.GOOGLE_APPLICATION_CREDENTIALS}}
        with:
          args: app deploy app.yaml
```

## Licence

[MIT License](https://github.com/actions-hub/gcloud/blob/master/LICENSE)
