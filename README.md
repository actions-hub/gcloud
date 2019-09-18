# gcloud

[![](https://github.com/exelban/gcloud/workflows/GitHub%20Registry%20:latest/badge.svg)](https://github.com/exelban/gcloud/actions)
[![](https://github.com/exelban/gcloud/workflows/GitHub%20Registry%20:version/badge.svg)](https://github.com/exelban/gcloud/actions)

[![Preview](https://serhiy.s3.eu-central-1.amazonaws.com/Github_repo/gcloud/logo_gcp_vertical_rgb.png?v=1)](https://cloud.google.com)

GitHub Action which allows interacting with [Google Cloud Platform](https://cloud.google.com).

## Usage
To use gcloud in your workflow use:

```yaml
- uses: exelban/gcloud@master
  env:
    PROJECT_ID: test
    APPLICATION_CREDENTIALS: ${{ secrets.GOOGLE_APPLICATION_CREDENTIALS }}
  with:
    args: info
```

Args put command which needs to be executed.

### Secrets
`APPLICATION_CREDENTIALS` - To authorize in GCP you need to have a [service account key](https://console.cloud.google.com/apis/credentials/serviceaccountkey). Required Base64 encoded service account key exported as JSON.
To encode a JSON file use: `base64 ~/<account_id>.json`

`PROJECT_ID` - must be provided to activate a specific project.

### Example

```yaml
name: gcloud
on: [push]

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1
      - uses: exelban/gcloud@master
        env:
          PROJECT_ID: ${{secrets.GCLOUD_PROJECT_ID}}
          APPLICATION_CREDENTIALS: ${{secrets.GOOGLE_APPLICATION_CREDENTIALS}}
        with:
          args: app deploy app.yaml
```

## Licence
[MIT License](https://github.com/exelban/gcloud/blob/master/LICENSE)
