FROM ghcr.io/k8s-at-home/ubuntu-focal:latest@sha256:595c46c6718b29f653d29c510bbba91caf4d678258c966caa26048292e478391

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

# hadolint ignore=DL3002
USER root

# hadolint ignore=DL3008,DL3015
RUN \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    libglib2.0-0 \
    libglu1-mesa \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='x86_64' ;; \
  esac \
  && \
  curl -fsSL -o /tmp/hyperhdr.deb \
    "https://github.com/awawa-dev/HyperHDR/releases/download/v${VERSION}/HyperHDR-${VERSION}-Linux-${ARCH}.deb" \
  && apt-get install -y /tmp/hyperhdr.deb \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

USER kah

EXPOSE 8090 19444 19445
VOLUME /config

COPY ./apps/hyperhdr/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
