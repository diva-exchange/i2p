FROM alpine:latest

LABEL author="Konrad Baechler <konrad@diva.exchange>" \
  maintainer="Konrad Baechler <konrad@diva.exchange>" \
  name="diva" \
  description="Distributed digital value exchange upholding security, reliability and privacy" \
  url="https://diva.exchange"

COPY conf/ /home/i2pd/conf/
COPY network/ /home/i2pd/network/
COPY htdocs/ /home/i2pd/htdocs/
COPY entrypoint.sh /home/i2pd/

# install deps && build i2p binary
RUN apk --no-cache --virtual build-dependendencies add \
    cmake \
    make \
    gcc \
    g++ \
    binutils \
    libtool \
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
  && cmake -DWITH_AESNI=ON -DWITH_AVX=ON . \
  && make \
  && strip i2pd \
  && mkdir /home/i2pd/bin \
  && mv /tmp/i2pd/build/i2pd /home/i2pd/bin/i2pd \
  && mkdir /home/i2pd/data \
  && mv /tmp/i2pd/contrib/certificates /home/i2pd/data/certificates \
  && mv /tmp/i2pd/LICENSE /home/i2pd/LICENSE \
  && mv /tmp/i2pd/ChangeLog /home/i2pd/ChangeLog \
  && cd /home/i2pd \
  && rm -fr /tmp/i2pd \
  && apk --no-cache --purge del build-dependendencies \
    fortify-headers \
    boost-python3 \
    python3 \
    gdbm \
    boost-unit_test_framework \
    boost-python2 \
    linux-headers \
    boost-prg_exec_monitor \
    boost-serialization \
    boost-wave \
    boost-wserialization \
    boost-math \
    boost-graph \
    boost-regex \
    pcre2 \
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
  && chown -R i2pd:i2pd /home/i2pd \
  && chmod 0700 /home/i2pd/bin/i2pd \
  && chmod +x /home/i2pd/entrypoint.sh

# 7070 I2P webconsole, 4444 I2P http proxy, 4445 I2P socks proxy
EXPOSE 7070 4444 4445

VOLUME [ "/home/i2pd/" ]
ENTRYPOINT ["/home/i2pd/entrypoint.sh"]
