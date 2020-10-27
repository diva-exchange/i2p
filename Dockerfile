FROM alpine:latest

LABEL author="Konrad Baechler <konrad@diva.exchange>" \
  maintainer="Konrad Baechler <konrad@diva.exchange>" \
  name="diva-i2p" \
  description="Distributed digital value exchange upholding security, reliability and privacy" \
  url="https://diva.exchange"

COPY conf/ /home/i2pd/conf/
COPY network/ /home/i2pd/network/
COPY htdocs/ /home/i2pd/htdocs/
COPY certificates/ /home/i2pd/data/certificates/
COPY entrypoint.sh /home/i2pd/

# install deps && build i2p binary
RUN mkdir /home/i2pd/tunnels.null \
  && mkdir /home/i2pd/tunnels.source.conf.d \
  && mkdir /home/i2pd/tunnels.conf.d \
  && mkdir /home/i2pd/bin \
  && apk --no-cache --virtual build-dependendencies add \
    cmake \
    make \
    gcc \
    g++ \
    binutils \
    libtool \
    libev-dev \
    check-dev \
    zlib-dev \
    boost-dev \
    build-base \
    openssl-dev \
    openssl \
    git \
    autoconf \
    automake \
  && cd /tmp \
  && git clone -b openssl https://github.com/PurpleI2P/i2pd.git \
  && cd /tmp/i2pd/build \
  && cmake . \
  && make \
  && strip i2pd \
  && mv /tmp/i2pd/build/i2pd /home/i2pd/bin/i2pd \
  && mv /tmp/i2pd/LICENSE /home/i2pd/LICENSE \
  && mv /tmp/i2pd/ChangeLog /home/i2pd/ChangeLog \
  # stubby, DNS-over-TLS client
  # build required libyaml
  && cd /tmp \
  && git clone https://github.com/yaml/libyaml.git \
  && cd libyaml \
  && ./bootstrap \
  && ./configure \
  && make install \
  # build getndns/stubby
  && cd /tmp \
  && git clone https://github.com/getdnsapi/getdns.git \
  && cd getdns \
  && git checkout master \
  && git submodule update --init \
  && mkdir build \
  && cd build \
  && cmake -DENABLE_STUB_ONLY=ON -DBUILD_STUBBY=ON -DUSE_LIBIDN2=OFF .. \
  && make \
  && strip stubby/stubby \
  && chmod 0700 stubby/stubby \
  && mv stubby/stubby /usr/local/bin/stubby \
  # clean up /tmp
  && cd /home/i2pd \
  && rm -rf /tmp/i2pd \
  && rm -rf /tmp/libyaml \
  && rm -rf /tmp/getdns \
  # remove build dependencies
  && apk --no-cache --purge del build-dependendencies \
  # i2p and stubby runtime dependencies
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
    libev \
    sed \
  && addgroup -g 1000 i2pd \
  && adduser -u 1000 -G i2pd -s /bin/sh -h "/home/i2pd" -D i2pd \
  && chown -R i2pd:i2pd /home/i2pd \
  && chmod 0700 /home/i2pd/bin/i2pd \
  && chmod +x /home/i2pd/entrypoint.sh

# 7070 I2P webconsole, 4444 I2P http proxy, 4445 I2P socks proxy
EXPOSE 7070 4444 4445

VOLUME [ "/home/i2pd/" ]
WORKDIR "/home/i2pd/"
ENTRYPOINT ["/home/i2pd/entrypoint.sh"]
