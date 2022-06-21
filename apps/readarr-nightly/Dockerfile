FROM ghcr.io/k8s-at-home/ubuntu-jammy:rolling@sha256:fdbafba13f7ed147d6f95ab5269ddaa7f17395e226f1bbc25381de4c6671442f

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
USER root

ENV \
  READARR__INSTANCE_NAME="Readarr" \
  READARR__BRANCH="nightly" \
  READARR__PORT="8787"

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
  esac \
  && \
  curl -fsSL -o /tmp/readarr.tar.gz \
    "https://readarr.servarr.com/v1/update/${READARR__BRANCH}/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=${ARCH}" \
  && tar ixzf /tmp/readarr.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/readarr.Update* \
  && \
  printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${READARR__BRANCH}" "${VERSION}" > /app/package_info \
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

EXPOSE ${READARR__PORT}/tcp

COPY ./apps/readarr-${READARR__BRANCH}/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/readarr-${READARR__BRANCH}/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="${READARR__INSTANCE_NAME} - ${READARR__BRANCH}" \
  org.opencontainers.image.source="https://github.com/Readarr/Readarr" \
  org.opencontainers.image.version="${VERSION}"
