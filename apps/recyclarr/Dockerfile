# hadolint ignore=DL3007
FROM ghcr.io/k8s-at-home/ubuntu:latest

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

USER root

ENV \
  DOTNET_BUNDLE_EXTRACT_BASE_DIR=/tmp

RUN \
  apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends \
    ca-certificates \
    unzip \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='x64' ;; \
    'linux/arm64') export ARCH='arm64' ;; \
  esac \
  && \
  curl -fsSL -o /tmp/app.zip \
    "https://github.com/recyclarr/recyclarr/releases/download/v${VERSION}/recyclarr-linux-${ARCH}.zip" \
  && unzip -q /tmp/app.zip -d /app \
  && apt-get remove -y unzip \
  && apt-get purge -y --autoremove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/ \
    /var/tmp/* \
  && chown -R kah:kah /app \
  && chmod -R 755 /app \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah

CMD ["/app/recyclarr"]

LABEL \
  org.opencontainers.image.authors="Robert Dailey" \
  org.opencontainers.image.title="Recyclarr" \
  org.opencontainers.image.source="https://github.com/recyclarr/recyclarr" \
  org.opencontainers.image.version="${VERSION}"
