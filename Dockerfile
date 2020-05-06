FROM alpine:latest

LABEL author="Konrad Baechler <konrad@diva.exchange>" \
  maintainer="Konrad Baechler <konrad@diva.exchange>" \
  name="diva" \
  description="Distributed digital value exchange upholding security, reliability and privacy" \
  url="https://diva.exchange"

COPY bin/i2pd-x86_64-alpine /home/i2pd/bin/
COPY ./i2pd_certs /home/i2pd_certs
COPY conf/* /home/i2pd/
COPY network/* /
COPY entrypoint.sh /
# darkhttpd static content
COPY htdocs/* /var/www/localhost/htdocs/

RUN mkdir -p "/home/i2pd/log" "/home/i2pd/data" \
  && apk --no-cache add \
    boost-filesystem \
    boost-system \
    boost-program_options \
    boost-date_time \
    boost-thread \
    boost-iostreams \
    openssl \
    musl-utils \
    libstdc++ \
    dnsmasq \
    tor \
    darkhttpd \
  && addgroup -g 1000 i2pd \
  && adduser -u 1000 -G i2pd -s /bin/sh -h "/home/i2pd" -D i2pd \
  && ln -s /home/i2pd_certs /home/i2pd/data/certificates \
  && chown -R i2pd:i2pd /home/i2pd \
  && chmod 0700 /home/i2pd/bin/i2pd-x86_64-alpine \
  && chmod +x /entrypoint.sh

# 7070 i2p webconsole, 4444 http proxy, 4447 socks proxy, 4446 tor proxy, 4445 darkhttpd
EXPOSE 7070 4444 4445 4446 4447

VOLUME [ "/home/i2pd/" ]
WORKDIR "/home/i2pd/"
ENTRYPOINT ["/entrypoint.sh"]
