FROM ghcr.io/k8s-at-home/ubuntu-focal:latest@sha256:bde16452d4d697b12405a948fd1f3f9954aeb3c84808fd84700768dc24d88282

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
