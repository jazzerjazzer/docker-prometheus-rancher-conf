# -----------------------------------------------------------------------------
# Inspired heavily by github.com/h0tbird/docker-confd, just need newer confd
# -----------------------------------------------------------------------------
FROM alpine:3.2
MAINTAINER Ryan Schmukler <ryan@slingingcode.com>

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

ENV CONFD_VERSION="0.12.0-alpha3" \
    ALPINE_GLIBC_URL="https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/" \
    GLIBC_PKG="glibc-2.21-r2.apk" \
    GLIBC_BIN_PKG="glibc-bin-2.21-r2.apk" \
    CONFD_INTERVAL="10" \
    CONFD_URL="https://github.com/kelseyhightower/confd/releases/download" \
    RANCHER_COMPOSE_VERSION="0.7.2" \
    RANCHER_PROMETHEUS_STACK="metrics" \
    RANCHER_PROMETHEUS_SERVICE="prometheus"

#------------------------------------------------------------------------------
# Install Confd:
#------------------------------------------------------------------------------

RUN apk add --update -t deps openssl \
    && apk add --update curl bash && cd /tmp \
    && wget ${ALPINE_GLIBC_URL}${GLIBC_PKG} ${ALPINE_GLIBC_URL}${GLIBC_BIN_PKG} \
    && wget ${CONFD_URL}/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 -O /bin/confd \
    && apk add --allow-untrusted ${GLIBC_PKG} ${GLIBC_BIN_PKG} \
    && /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib \
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
    && chmod +x /bin/confd \
    && apk del --purge deps \
    && rm -rf /tmp/* /var/cache/apk/*

#------------------------------------------------------------------------------
# Install rancher-compose:
#------------------------------------------------------------------------------

RUN curl -s -L "https://github.com/rancher/rancher-compose/releases/download/v${RANCHER_COMPOSE_VERSION}/rancher-compose-linux-amd64-v${RANCHER_COMPOSE_VERSION}.tar.gz" > /tmp/rancher-compose.tar.gz && \
    tar -xvzf /tmp/rancher-compose.tar.gz && \
    mv rancher-compose-v${RANCHER_COMPOSE_VERSION}/rancher-compose /usr/bin/rancher-compose && \
    rm -rf rancher-compose*

#------------------------------------------------------------------------------
# Actual work
#------------------------------------------------------------------------------

ADD confd /etc/confd
ADD run.sh /run.sh
ADD reload.sh /reload.sh


VOLUME /etc/prometheus

ENTRYPOINT [ "/run.sh" ]
