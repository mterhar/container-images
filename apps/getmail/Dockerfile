FROM ghcr.io/k8s-at-home/ubuntu-focal:latest@sha256:bde16452d4d697b12405a948fd1f3f9954aeb3c84808fd84700768dc24d88282

ARG VERSION
USER root

# hadolint ignore=DL3008
RUN \
  apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends \
    python3-pip \
  && pip3 install --no-cache-dir getmail6=="${VERSION}" \
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/ \
    /var/tmp/*

USER kah

CMD [ "/usr/local/bin/getmail" ]
