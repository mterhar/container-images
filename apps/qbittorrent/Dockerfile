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
  apt-get -qq update \
  && \
  apt-get install -y \
    geoip-bin \
    jq \
    p7zip-full \
    python3 \
    unrar \
    unzip \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export DOWNLOAD_URL=$(curl -sX GET "https://api.github.com/repos/userdocs/qbittorrent-nox-static/releases" | jq -r --arg VERSION "$VERSION" '.[] | select(.prerelease==false) | select(.tag_name | startswith("release-4.4.0")) | .assets | .[] | select(.browser_download_url | endswith("x86_64-qbittorrent-nox")) | .browser_download_url') ;; \
    'linux/arm64') export DOWNLOAD_URL=$(curl -sX GET "https://api.github.com/repos/userdocs/qbittorrent-nox-static/releases" | jq -r --arg VERSION "$VERSION" '.[] | select(.prerelease==false) | select(.tag_name | startswith("release-4.4.0")) | .assets | .[] | select(.browser_download_url | endswith("aarch64-qbittorrent-nox")) | .browser_download_url') ;; \
  esac \
  && echo $DOWNLOAD_URL \
  && curl -fsSL -o /app/qbittorrent-nox "${DOWNLOAD_URL}" \
  && chmod +x /app/qbittorrent-nox \
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
