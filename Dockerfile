FROM alpine:3.7
LABEL maintainer "Andrew Johnson <andrew.johnson@intuitivetech.com>"

EXPOSE 8000

WORKDIR /opt

### Environment variables
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm'

### Install app
RUN apk --no-cache upgrade && \
    apk add --no-cache --virtual=build \
        python3-dev \
        postgresql-dev \
        jpeg-dev \
        musl-dev \
        gcc \
        zlib-dev && \
    apk add --no-cache --virtual=run \
        jpeg \
        ssmtp \
        postgresql-libs \
        python3 \
        su-exec && \
    pip3 --no-cache-dir install --upgrade setuptools pip && \
    pip3 --no-cache-dir install --upgrade mezzanine psycopg2 && \
    apk del --no-cache --purge \
        build-deps && \
    rm -rf /tmp/* \
        /var/cache/apk/* \
        /var/tmp/*

ADD entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]
