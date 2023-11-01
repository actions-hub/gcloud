FROM google/cloud-sdk:451.0.1-alpine

COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["info"]
