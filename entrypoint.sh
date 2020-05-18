#!/bin/sh
#
# Author/Maintainer: konrad@diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

# optional - bind to the diva service backend (see /conf/tunnels.conf)
DIVA_IP=${DIVA_IP:-127.0.0.1}

# overwrite resolv.conf
cat </home/i2pd/network/resolv.conf >/etc/resolv.conf

# overwrite dnsmasq.conf
cat </home/i2pd/network/dnsmasq.conf >/etc/dnsmasq.conf

# networking, see resolv.conf
dnsmasq -a 127.0.1.1 \
  --no-hosts \
  --local-service \
  --address=/diva.local/${DIVA_IP} \

# httpd server
/usr/bin/darkhttpd /home/i2pd/htdocs \
  --port 8080 \
  --daemon \
  --chroot \
  --uid i2pd \
  --gid i2pd \
  --log /dev/stdout \
  --no-listing

# tor proxy
/usr/bin/tor -f /home/i2pd/network/torrc

# see configs: /conf/i2pd.conf
su i2pd -c "/home/i2pd/bin/i2pd --datadir=/home/i2pd/data --conf=/home/i2pd/conf/i2pd.conf"
