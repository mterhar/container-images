FROM ghcr.io/k8s-at-home/ubuntu-focal:latest@sha256:595c46c6718b29f653d29c510bbba91caf4d678258c966caa26048292e478391

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
