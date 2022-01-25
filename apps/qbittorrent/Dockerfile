# hadolint ignore=DL3007
FROM ghcr.io/k8s-at-home/ubuntu:latest

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

# Proper way to set config directory
ENV HOME=/config \
    XDG_CONFIG_HOME=/config \
    XDG_DATA_HOME=/config \
    WEBUI_PORT=8080

USER root

# hadolint ignore=DL3008,DL3013,DL3015,SC2086
RUN \
  export EXTRA_INSTALL_ARG="binutils"; \
  apt-get -qq update \
  && \
  apt-get install -y \
    geoip-bin \
    jq \
    p7zip-full \
    python3 \
    unrar \
    unzip \
    ${EXTRA_INSTALL_ARG} \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH="x86_64" ;; \
    'linux/arm64') export ARCH="aarch64" ;; \
  esac \
  && curl -fsSL -o /app/qbittorrent-nox "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/${ARCH}-qbittorrent-nox" \
  && chmod +x /app/qbittorrent-nox \
  && \
  apt-get remove -y ${EXTRA_INSTALL_ARG} \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/ \
  && chown -R kah:kah /app \
  && chmod -R u=rwX,go=rX /app \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc \
  && update-ca-certificates

USER kah

EXPOSE 6881 6881/udp ${WEBUI_PORT}

COPY ./apps/qbittorrent/qBittorrent.conf /app/qBittorrent.conf
COPY ./apps/qbittorrent/shim/config.py /shim/config.py
COPY ./apps/qbittorrent/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="qBittorrent" \
  org.opencontainers.image.source="https://github.com/qbittorrent/qBittorrent" \
  org.opencontainers.image.version="${VERSION}"
