#!/bin/sh
#
# Author/Maintainer: konrad@diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

ENABLE_TUNNELS=${ENABLE_TUNNELS:-0}
IP_BRIDGE=${IP_BRIDGE:-`ip route | awk '/default/ { print $3; }'`}

TUNNELS_DIR=/home/i2pd/tunnels.null
IP_CONTAINER=`ip route get 1 | awk '{ print $NF; exit; }'`

if [[ ${ENABLE_TUNNELS} == 1 ]]
then
  TUNNELS_DIR=/home/i2pd/tunnels.conf.d
  rm /home/i2pd/tunnels.conf.d/*
  cp /home/i2pd/tunnels.source.conf.d/* /home/i2pd/tunnels.conf.d/
  sed 's/\$IP_CONTAINER/'"${IP_CONTAINER}"'/g ; s/\$IP_BRIDGE/'"${IP_BRIDGE}"'/g' \
    /home/i2pd/conf/tunnels.conf.d/*.conf
fi

sed 's/\$IP_CONTAINER/'"${IP_CONTAINER}"'/g ; s/\$TUNNELS_DIR/'"${TUNNELS_DIR}"'/g' \
  /home/i2pd/conf/i2pd.org.conf >/home/i2pd/conf/i2pd.conf

# overwrite resolv.conf - forces the container to use stubby as a resolver
cat </home/i2pd/network/resolv.conf >/etc/resolv.conf

# DNS-over-TLS, -C path to config
/usr/local/bin/stubby -l -C /home/i2pd/network/stubby.yml &

# see configs: /conf/i2pd.conf
su i2pd -c "/home/i2pd/bin/i2pd --datadir=/home/i2pd/data --conf=/home/i2pd/conf/i2pd.conf"
