FROM alpine:edge
MAINTAINER George Kutsurua <g.kutsurua@gmail.com>

RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories &&\
    apk add --no-cache postgis@testing postgresql-pglogical@testing postgresql-contrib \
                       postgresql-client postgresql-libs sudo

ENV PGDATA=/var/lib/postgresql/data \
    LANG=en_US.utf8 \
    LC_ALL=en_US.utf8 \
    LANGUAGE=en_US.utf8

VOLUME $PGDATA

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 5432