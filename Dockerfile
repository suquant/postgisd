FROM alpine:edge
MAINTAINER George Kutsurua <g.kutsurua@gmail.com>

ENV POSTGIS_VERSION=2.2.1 \
    GEOS_VERSION=3.5.0 \
    PROJ4_VERSION=4.9.2 \
    GDAL_VERSION=2.0.2

RUN apk update && apk upgrade && \
    apk add curl libxml2 json-c libxml2-dev json-c-dev alpine-sdk autoconf automake libtool \
    postgresql postgresql-contrib postgresql-dev && \
    curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" && \
    chmod +x /usr/bin/gosu && \
    mkdir -p /tmp/build && cd /tmp/build && \
    curl -o postgis-${POSTGIS_VERSION}.tar.gz -sSL http://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz && \
    curl -o geos-${GEOS_VERSION}.tar.gz -sSL https://github.com/libgeos/libgeos/archive/${GEOS_VERSION}.tar.gz && \
    curl -o proj4-${PROJ4_VERSION}.tar.gz -sSL https://github.com/OSGeo/proj.4/archive/${PROJ4_VERSION}.tar.gz && \
    curl -o gdal-${GDAL_VERSION}.tar.gz -sSL http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz && \
    tar xzf proj4-${PROJ4_VERSION}.tar.gz && \
    tar xzf geos-${GEOS_VERSION}.tar.gz && \
    tar xzf gdal-${GDAL_VERSION}.tar.gz && \
    tar xzf postgis-${POSTGIS_VERSION}.tar.gz && \
    cd /tmp/build/proj.4* && ./configure --prefix=/usr --enable-silent-rules && make -s && make -s install && \
    cd /tmp/build/libgeos* && ./autogen.sh && ./configure --prefix=/usr CFLAGS="-D__sun -D__GNUC__"  CXXFLAGS="-D__GNUC___ -D__sun" && make -s && make -s install && \
    cd /tmp/build/gdal* && ./configure --prefix=/usr --enable-silent-rules --with-static-proj4=/usr/lib && make -s && make -s install && \
    cd /tmp/build/postgis* && ./autogen.sh && ./configure --prefix=/usr --with-projdir=/usr && \
    cd /tmp/build/postgis* && \
    echo "PERL = /usr/bin/perl" >> extensions/postgis/Makefile && \
    echo "PERL = /usr/bin/perl" >> extensions/postgis_topology/Makefile && make -s && make -s install && \
    apk del libxml2-dev json-c-dev alpine-sdk autoconf automake libtool git postgresql-dev --force && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/build

ENV LANG=en_US.utf8 \
    PGDATA=/var/lib/postgresql/data

VOLUME $PGDATA

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["postgres"]

EXPOSE 5432