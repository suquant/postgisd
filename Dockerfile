FROM ubuntu:16.04
MAINTAINER George Kutsurua <g.kutsurua@gmail.com>

ENV POSTGRES_VERSION=9.6 \
    POSTGIS_VERSION=2.3 \
    LANG=en_US.utf8 \
    LC_ALL=en_US.utf8 \
    LANGUAGE=en_US.utf8 \
    PGDATA=/var/lib/postgresql/data

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl sudo && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-${POSTGRES_VERSION} \
                       postgresql-server-dev-${POSTGRES_VERSION} \
                       postgresql-client-${POSTGRES_VERSION} \
                       postgresql-contrib-${POSTGRES_VERSION} \
                       postgresql-${POSTGRES_VERSION}-postgis-${POSTGIS_VERSION} \
                       postgresql-${POSTGRES_VERSION}-repmgr \
                       postgresql-${POSTGRES_VERSION}-pgrouting && \
    apt-get clean -y && \
    locale-gen en_US.UTF-8

VOLUME $PGDATA

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["postgres"]

EXPOSE 5432