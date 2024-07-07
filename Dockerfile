FROM alpine:3.16

LABEL author="DIVA.EXCHANGE Association <contact@diva.exchange>" \
  maintainer="DIVA.EXCHANGE Association <contact@diva.exchange>" \
  name="diva-i2p" \
  description="Distributed digital value exchange upholding security, reliability and privacy" \
  url="https://diva.exchange"


RUN apk --no-cache --virtual build-dependendencies add \
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
  miniupnpc \
  miniupnpc-dev

COPY conf/ /i2pd/conf/
COPY network/ /i2pd/network/
COPY certificates/ /i2pd/data/certificates/

# install deps && build i2p binary
RUN mkdir -p /i2pd/data/addressbook \
  && mkdir /i2pd/tunnels.null \
  && mkdir /i2pd/tunnels.source.conf.d \
  && mkdir /i2pd/tunnels.conf.d \
  && mkdir /i2pd/bin 

RUN cd /tmp \
  && git clone --depth 1 -b openssl https://github.com/PurpleI2P/i2pd.git 

RUN cd /tmp/i2pd/build \
  && cmake -DWITH_AESNI=ON -DWITH_UPNP=ON . \
  && make -j $(nproc) \
  && strip i2pd \
  && mv /tmp/i2pd/build/i2pd /i2pd/bin/i2pd \
  && mv /tmp/i2pd/LICENSE /i2pd/LICENSE \
  && mv /tmp/i2pd/ChangeLog /i2pd/ChangeLog \
  # clean up /tmp
  && cd /i2pd \
  && rm -rf /tmp/i2pd 

# remove build dependencies
RUN apk --no-cache --purge del build-dependendencies \
  # i2p runtime dependencies
  && apk --no-cache add \
  boost-filesystem \
  boost-system \
  boost-program_options \
  boost-date_time \
  openssl \
  musl-utils \
  libstdc++ \
  sed \
  miniupnpc 
  
COPY entrypoint.sh /

RUN cp /i2pd/conf/addresses-initial.org.csv /i2pd/data/addressbook/addresses.csv \
  && addgroup -g 1000 i2pd \
  && adduser -u 1000 -G i2pd -s /bin/sh -h "/i2pd" -D i2pd \
  && chown -R i2pd:i2pd /i2pd \
  && chmod 0700 /i2pd/bin/i2pd \
  && chmod +x /entrypoint.sh \
  && mkdir -p /home/i2pd/

VOLUME [ "/home/i2pd/data/" ]
WORKDIR "/home/i2pd/"
ENTRYPOINT ["/entrypoint.sh"]
