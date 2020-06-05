#!/bin/sh
#
# Author/Maintainer: konrad@diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

# optional - bind to the diva service backend (see /conf/tunnels.conf)
DNS_CATCH_ALL=${DIVA_IP:-127.0.0.1}

# overwrite dnsmasq.conf
cat </home/i2pd/network/dnsmasq.conf >/etc/dnsmasq.conf

# networking, see resolv.conf
dnsmasq -a 127.0.1.1 \
  --no-hosts \
  --local-service \
  --address=/#/${DNS_CATCH_ALL} \

# see configs: /conf/i2pd.conf
su i2pd -c "/home/i2pd/bin/i2pd --datadir=/home/i2pd/data --conf=/home/i2pd/conf/i2pd.conf"
