FROM ghcr.io/k8s-at-home/ubuntu-focal:latest@sha256:595c46c6718b29f653d29c510bbba91caf4d678258c966caa26048292e478391

USER root

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends \
    nut-server \
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/ \
    /var/tmp/*

WORKDIR /config

COPY ./apps/network-ups-tools/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
