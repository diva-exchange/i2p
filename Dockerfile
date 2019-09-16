FROM alpine:latest

LABEL author="Konrad Baechler <konrad@getdiva.org>" \
  maintainer="Konrad Baechler <konrad@getdiva.org>" \
  name="diva" \
  description="Distributed digital value exchange upholding security, reliability and privacy" \
  url="https://getdiva.org"

COPY bin/i2pd-x86_64-aesni /home/i2pd/bin/
COPY ./i2pd_certs /home/i2pd_certs
COPY conf/* /home/i2pd/
COPY network/* /
COPY entrypoint.sh /

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
    nano \
    dnsmasq \
    iputils \
  && addgroup -g 1000 i2pd \
  && adduser -u 1000 -G i2pd -s /bin/sh -h "/home/i2pd" -D i2pd \
  && ln -s /home/i2pd_certs /home/i2pd/data/certificates \
  && chown -R i2pd:i2pd /home/i2pd \
  && chmod 0700 /home/i2pd/bin/i2pd-x86_64-aesni \
  && chmod +x /entrypoint.sh

# 7070 i2p webconsole, 4444 i2p httpproxy
EXPOSE 7070 4444

WORKDIR "/home/i2pd/"
ENTRYPOINT ["/entrypoint.sh"]
