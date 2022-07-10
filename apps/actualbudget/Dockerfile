FROM ghcr.io/k8s-at-home/ubuntu-focal:rolling@sha256:7f1b8af0e171af574601647215678391d11bff9236525a190e55f5a53e1d5505

ARG APP_VERSION=1.0.3
### Based on https://github.com/linuxserver/docker-wikijs
# Give ourselves root for a bit
USER root

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs 

RUN apt-get install -qq --no-install-recommends \
    gcc \
    g++ \
    make \
    openssl \
    tini && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
ENV NODE_ENV=production
COPY entrypoint.sh /entrypoint.sh

RUN npm install -g -s --no-progress yarn && \
    npm rebuild bcrypt --build-from-source && \
    mkdir -p /home/kah && mkdir -p /data/user-files && mkdir -p /data/server-files && \
    chown -R kah:kah /app /home/kah/ /data && \
    chmod +x /entrypoint.sh 

USER kah

RUN curl -L https://github.com/actualbudget/actual-server/archive/refs/tags/v${APP_VERSION}.tar.gz | \
    tar -zxv -C /app/ && \
    mv actual-server-${APP_VERSION}/* .
RUN yarn install --production

EXPOSE 5006

VOLUME ["/data/user-files", "/data/server-files"]

ENTRYPOINT ["/usr/bin/tini","-g",  "--"]
CMD ["/entrypoint.sh"]