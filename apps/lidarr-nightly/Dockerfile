FROM ghcr.io/k8s-at-home/ubuntu-jammy:rolling@sha256:52f4d9e09120d604aa3815ce2a4771e67d9b48e2451d780af05514c4b087baf5

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
USER root

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    ca-certificates \
    libchromaprint-tools \
    libicu70 \
    libsqlite3-0 \
    xmlstarlet \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='x64' ;; \
    'linux/arm64') export ARCH='arm64' ;; \
    'linux/arm/v7') export ARCH='arm' ;; \
  esac \
  && \
  curl -fsSL -o /tmp/lidarr.tar.gz \
    "https://lidarr.servarr.com/v1/update/nightly/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=${ARCH}" \
  && tar ixzf /tmp/lidarr.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/lidarr.Update* \
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

EXPOSE 8686

COPY ./apps/lidarr-nightly/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/lidarr-nightly/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="Lidarr" \
  org.opencontainers.image.source="https://github.com/Lidarr/Lidarr" \
  org.opencontainers.image.version="${VERSION}"
