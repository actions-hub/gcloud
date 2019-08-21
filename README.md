# gcloud

GitHub Action which allows to interact with [Google Cloud Platform](https://cloud.google.com).

[![Preview](https://serhiy.s3.eu-central-1.amazonaws.com/Github_repo/gcloud/logo_gcp_vertical_rgb.png?v=1)](https://cloud.google.com)

## Usage
To use gcloud in you workflow use:

```sh
- uses: exelban/gcloud@master
  env:
    PROJECT_ID: test
    APPLICATION_CREDENTIALS: ${{ secrets.GOOGLE_APPLICATION_CREDENTIALS }}
  with:
    args: info
```

If you prefer to use a docker image:

```sh
- uses: 'docker://exelban/gcloud:latest'
  env:
    PROJECT_ID: test
    APPLICATION_CREDENTIALS: ${{ secrets.GOOGLE_APPLICATION_CREDENTIALS }}
  with:
    args: info
```

In args put command which need to be executed.

### Secrets
`APPLICATION_CREDENTIALS` - To authorize in GCP you need to have a [service account key](https://console.cloud.google.com/apis/credentials/serviceaccountkey?_ga=2.84485854.-650438822.1565472343). Required Base64 encoded service account key exported as JSON.
To encode a JSON file use: `base64 ~/<account_id>.json`

`PROJECT_ID` - must to be provided to activate a specific project.

### Example

```sh
name: gcloud
on: [push]

jobs:
  info:
    name: Information
    steps:
    - uses: exelban/gcloud@master
      env:
        PROJECT_ID: test
        APPLICATION_CREDENTIALS: ${{ secrets.GOOGLE_APPLICATION_CREDENTIALS }}
      with:
          args: info
```

#### Dynamic `GOOGLE_PROJECT_ID`
```sh
name: gcloud
on: [push]

jobs:
  deploy:
    name: Deploy
    steps:
    - uses: exelban/gcloud@master
      env:
        PROJECT_ID: test
        APPLICATION_CREDENTIALS: ${{ secrets.GOOGLE_APPLICATION_CREDENTIALS }}
      with:
          args: info
```

## Licence
[MIT License](https://github.com/exelban/gcloud/blob/master/LICENSE)
