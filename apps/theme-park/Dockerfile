FROM nginx:stable-alpine

ARG VERSION

USER root

RUN curl -fsSL "https://github.com/GilbN/theme.park/archive/${VERSION}.tar.gz" | tar xzf - -C /tmp --strip-components 1 && \
cp -R /tmp/css/ /usr/share/nginx/html/ && \
cp -R /tmp/resources/ /usr/share/nginx/html/ && \
cp /tmp/index.html /usr/share/nginx/html/ && \
rm -rf /tmp

# No need to run as unprivileged user
# Nginx uses www-data which is unprivileged

LABEL \
  org.opencontainers.image.title="theme.park" \
  org.opencontainers.image.source="https://github.com/GilbN/theme.park" \
  org.opencontainers.image.version="${VERSION}"

