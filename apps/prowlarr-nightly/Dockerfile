FROM ghcr.io/k8s-at-home/ubuntu-focal:latest@sha256:595c46c6718b29f653d29c510bbba91caf4d678258c966caa26048292e478391

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

USER root

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    libicu66 \
    sqlite3 \
    xmlstarlet \
    jq \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='x64' ;; \
    'linux/arm64') export ARCH='arm64' ;; \
  esac \
  && \
  curl -fsSL -o /tmp/prowlarr.tar.gz \
    "https://prowlarr.servarr.com/v1/update/nightly/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=${ARCH}" \
  && tar ixzf /tmp/prowlarr.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/prowlarr.Update* \
  && \
  printf "UpdateMethod=docker\nBranch=nightly\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${VERSION}" > /app/package_info \
  && \
  apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/ \
  && chown -R kah:kah /app \
  && chmod -R u=rwX,go=rX /app \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah

EXPOSE 9696

COPY ./apps/prowlarr-nightly/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="Prowlarr" \
  org.opencontainers.image.source="https://github.com/Prowlarr/Prowlarr" \
  org.opencontainers.image.version="${VERSION}"
