FROM chenhw2/alpine:base as dnsforwarder

RUN export BUILD_DEPS="gcc git make libc-dev" \
    && apk add --update $BUILD_DEPS \
    && git clone https://github.com/aa65535/hev-dns-forwarder /tmp/dnsforwarder \
    && cd /tmp/dnsforwarder \
    && make \
    && mv /tmp/dnsforwarder/src/hev-dns-forwarder /usr/local/bin/dnsforwarder \
    && apk del --purge $BUILD_DEPS \
    && rm -rf /tmp/* /var/cache/apk/*

FROM shadowsocks/shadowsocks-libev


ENV SERVER_PORT=443
ENV METHOD=chacha20-ietf-poly1305
ENV DNS_ADDRS="172.104.183.58,8.8.8.8,8.8.4.4"
#ENV ARGS="--plugin /bin/v2ray-plugin --plugin-opts 'server;host=www.microsoft.com'"

USER root

COPY --from=dnsforwarder /usr/local/bin/dnsforwarder /usr/local/bin/dnsforwarder

RUN set -x \
  && cd /tmp \
  && wget https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz \
  && tar -xzvf v2ray-plugin-linux-amd64-v1.3.2.tar.gz \
  && mv ./v2ray-plugin_linux_amd64 /bin/v2ray-plugin \
  && rm /tmp/v2ray-plugin-linux-amd64-v1.3.2.tar.gz

# USER nobody

EXPOSE 443
EXPOSE 53/udp
EXPOSE 5300/udp

STOPSIGNAL SIGINT

COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["ss-server"]