FROM ghcr.io/k8s-at-home/ubuntu-focal:latest@sha256:595c46c6718b29f653d29c510bbba91caf4d678258c966caa26048292e478391

ARG VERSION
USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  curl -L \
    "https://mediaarea.net/repo/deb/repo-mediaarea_1.0-12_all.deb" \
    -o /tmp/key.deb \
  && dpkg -i /tmp/key.deb \
  && echo "deb https://mediaarea.net/repo/deb/ubuntu focal main" | tee /etc/apt/sources.list.d/mediaarea.list \
  && \
  apt-get -qq update \
  && apt-get -qq install -y gnupg \
	&& \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official.list \
  && apt-get -qq update \
  && \
  apt-get -qq install -y \
    ca-certificates \
    mono-complete \
    ca-certificates-mono \
    libmediainfo0v5 \
    xmlstarlet \
    jq \
  && \
  curl -fsSL -o /tmp/sonarr.tar.gz \
    "https://download.sonarr.tv/v3/develop/${VERSION}/Sonarr.develop.${VERSION}.linux.tar.gz" \
  && tar ixzf /tmp/sonarr.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/Sonarr.Update* \
  && \
  printf "UpdateMethod=docker\nBranch=develop\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${VERSION}" > /app/package_info \
  && \
  gpgconf --kill all \
  && apt-get remove -y gnupg \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/cache/apt/* \
    /var/tmp/ \
  && chown -R kah:kah /app \
  && chmod -R u=rwX,go=rX /app \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah

EXPOSE 8989

COPY ./apps/sonarr-develop/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="Sonarr" \
  org.opencontainers.image.source="https://github.com/Sonarr/Sonarr" \
  org.opencontainers.image.version="${VERSION}"
