FROM debian:11-slim

LABEL author="Konrad Baechler <konrad@diva.exchange>" \
  maintainer="Konrad Baechler <konrad@diva.exchange>" \
  name="diva-i2p" \
  description="Distributed digital value exchange upholding security, reliability and privacy" \
  url="https://diva.exchange"

COPY conf/ /home/i2pd/conf/
COPY network/ /home/i2pd/network/
COPY certificates/ /home/i2pd/data/certificates/
COPY entrypoint.sh /

RUN mkdir -p /home/i2pd/data/addressbook \
  && mkdir /home/i2pd/tunnels.null \
  && mkdir /home/i2pd/tunnels.source.conf.d \
  && mkdir /home/i2pd/tunnels.conf.d \
  && cd /home/i2pd/ \
  && apt-get update \
  && apt-get -y install wget iproute2 procps bash \
  && wget -O i2pd.deb http://http.us.debian.org/debian/pool/main/i/i2pd/i2pd_2.39.0-1_arm64.deb \
  && apt-get -y install ./i2pd.deb \
  && cp /home/i2pd/conf/addresses-initial.org.csv /home/i2pd/data/addressbook/addresses.csv \
  && chmod +x /entrypoint.sh

# 7070 I2P webconsole, 4444 I2P http proxy, 4445 I2P socks proxy
EXPOSE 7070 4444 4445

VOLUME [ "/home/i2pd/data/" ]
WORKDIR "/home/i2pd/"
ENTRYPOINT ["/entrypoint.sh"]
