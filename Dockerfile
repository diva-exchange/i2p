FROM alpine:latest

LABEL author="Konrad Baechler <konrad@diva.exchange>" \
  maintainer="Konrad Baechler <konrad@diva.exchange>" \
  name="diva" \
  description="Distributed digital value exchange upholding security, reliability and privacy" \
  url="https://diva.exchange"

WORKDIR /home

# 1. install deps
RUN apk --no-cache add \
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
  automake

# 2. build i2pd binary
RUN git clone -b openssl https://github.com/PurpleI2P/i2pd.git \
  && cd i2pd/build \
  && cmake -DWITH_AESNI=ON . \
  && make \
  && strip i2pd

# 3. prepare final image
FROM alpine:latest
WORKDIR /home/i2pd
RUN apk --no-cache add ca-certificates \
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
  darkhttpd

COPY --from=0 /home/i2pd/contrib/certificates /home/i2pd/data/certificates
COPY --from=0 /home/i2pd/build/i2pd /home/i2pd/bin/
COPY --from=0 /home/i2pd/LICENSE /home/i2pd/
COPY --from=0 /home/i2pd/ChangeLog /home/i2pd/

COPY conf/ /home/i2pd/conf/
COPY network/ /home/i2pd/network/
COPY htdocs/ /home/i2pd/htdocs/
COPY entrypoint.sh .

RUN addgroup -g 1000 i2pd \
  && adduser -u 1000 -G i2pd -s /bin/sh -h "/home/i2pd" -D i2pd \
  && chown -R i2pd:i2pd /home/i2pd \
  && chmod 0700 /home/i2pd/bin/i2pd \
  && chmod +x /home/i2pd/entrypoint.sh

# 7070 I2P webconsole, 4444 I2P http proxy, 4445 I2P socks proxy, 9050 TOR proxy, 8080 darkhttpd
EXPOSE 7070 4444 4445 9050 8080

VOLUME [ "/home/i2pd/" ]
ENTRYPOINT ["/home/i2pd/entrypoint.sh"]

