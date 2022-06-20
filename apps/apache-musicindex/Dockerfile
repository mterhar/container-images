FROM ghcr.io/k8s-at-home/ubuntu-focal:latest@sha256:595c46c6718b29f653d29c510bbba91caf4d678258c966caa26048292e478391

ARG VERSION
USER root

RUN apt update \
    && apt-get install -y apache2 ssl-cert libapache2-mod-musicindex \
    && apt-get -y clean all \
    && mkdir -p /music /cache \
    && chown -R kah:kah /music /cache \
    && a2enmod ssl musicindex \
    && a2ensite default-ssl \
    && rm -rf /var/www/html \
    && ln -s /music /var/www/html

COPY ./apps/apache-musicindex/config/musicindex.conf /etc/apache2/conf-enabled/
COPY ./apps/apache-musicindex/entrypoint.sh /entrypoint.sh

WORKDIR /music

EXPOSE 80 443

CMD ["/entrypoint.sh"]
