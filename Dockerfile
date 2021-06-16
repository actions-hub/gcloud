FROM google/cloud-sdk:345.0.0-alpine

COPY LICENSE README.md /

RUN gcloud components install kubectl

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["info"]
