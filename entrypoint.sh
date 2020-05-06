#!/bin/sh
#
# Author/Maintainer: konrad@diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

# optional - bind to the diva service backend (see /conf/tunnels.conf)
DIVA_IP=${DIVA_IP:-127.0.0.1}

# overwrite resolv.conf
cat </resolv.conf >/etc/resolv.conf

# overwrite dnsmasq.conf
cat </dnsmasq.conf >/etc/dnsmasq.conf

# overwrite proxy.pac
cat </proxy.pac >/var/www/localhost/htdocs/proxy.pac

# networking, see resolv.conf
dnsmasq -a 127.0.1.1 \
  --no-hosts \
  --local-service \
  --address=/diva.local/${DIVA_IP} \

# httpd server
/usr/bin/darkhttpd /var/www/localhost/htdocs \
  --port 4445 \
  --daemon \
  --chroot \
  --uid darkhttpd \
  --gid www-data \
  --log /dev/null \
  --no-listing

# tor proxy
/usr/bin/tor -f /torrc

# see configs: /conf/i2pd.conf
su i2pd -c "/home/i2pd/bin/i2pd-x86_64-alpine --datadir=/home/i2pd/data --conf=/home/i2pd/i2pd.conf"
