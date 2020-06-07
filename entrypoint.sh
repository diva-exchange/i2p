#!/bin/sh
#
# Author/Maintainer: konrad@diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

# overwrite resolv.conf - forces the container to use stubby as a resolver
cat </home/i2pd/network/resolv.conf >/etc/resolv.conf

# DNS-over-TLS, -C path to config
/usr/local/bin/stubby -l -C /home/i2pd/network/stubby.yml &

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
