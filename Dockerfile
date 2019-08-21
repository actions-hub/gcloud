FROM google/cloud-sdk:258.0.0-alpine

LABEL name="gcloud"
LABEL version="1.0.0"
LABEL repository="http://github.com/exelban/gcloud"
LABEL homepage="http://github.com/exelban/gcloud"
LABEL maintainer="Serhiy Mytrovtsiy <mitrovtsiy@ukr.net>"

LABEL com.github.actions.name="Google Cloud Platform (GCP) CLI - gcloud"
LABEL com.github.actions.description="GitHub action with all the components of the Google Cloud SDK"
LABEL com.github.actions.icon="cloud"
LABEL com.github.actions.color="blue"

COPY README.md /

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]