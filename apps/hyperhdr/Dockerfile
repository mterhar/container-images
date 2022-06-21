FROM ghcr.io/k8s-at-home/ubuntu-focal:rolling@sha256:7f1b8af0e171af574601647215678391d11bff9236525a190e55f5a53e1d5505

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
