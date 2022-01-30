# hadolint ignore=DL3007
FROM ghcr.io/k8s-at-home/ubuntu:latest

USER root

ARG VERSION

ENV \
  DOTNET_BUNDLE_EXTRACT_BASE_DIR=/tmp

RUN \
  apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends \
    bash \
    curl \
    unzip \
  && curl -fsSL -o /tmp/app.zip https://github.com/rcdailey/trash-updater/releases/download/v${VERSION}/trash-linux-x64.zip \
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
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc \
  && update-ca-certificates

RUN printf "UpdateMethod=docker\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${VERSION}" > /app/package_info

USER kah

CMD ["/app/trash"]

LABEL "maintainer"="Sean O'Brien <sean@obrienfamily.org>"
LABEL "org.opencontainers.image.source"="https://github.com/k8s-at-home/container-images"
