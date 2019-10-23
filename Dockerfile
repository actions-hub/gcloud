FROM google/cloud-sdk:268.0.0-alpine

LABEL name="gcloud"
LABEL version="1.0.0"
LABEL repository="https://github.com/exelban/gcloud"
LABEL homepage="https://github.com/exelban/gcloud"
LABEL maintainer="Serhiy Mytrovtsiy <mitrovtsiy@ukr.net>"

LABEL com.github.actions.name="Google Cloud Platform (GCP) CLI - gcloud"
LABEL com.github.actions.description="GitHub Action with all the components of the Google Cloud SDK"
LABEL com.github.actions.icon="cloud"
LABEL com.github.actions.color="blue"

COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["info"]
