#!/bin/sh
#
# Author/Maintainer: konrad@diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

DISABLE_TUNNELS=${DISABLE_TUNNELS:-0}
PORT_BACKEND=${PORT_BACKEND:-3902}
PORT_EXPOSED=${PORT_EXPOSED:-${PORT_BACKEND}}
IP_BRIDGE=${IP_BRIDGE:-`ip route | awk '/default/ { print $3; }'`}
IP_CONTAINER=`ip route get 1 | awk '{ print $NF; exit; }'`

sed 's/\$IP_CONTAINER/'"${IP_CONTAINER}"'/g' /home/i2pd/conf/i2pd.org.conf >/home/i2pd/conf/i2pd.conf

if [[ ${DISABLE_TUNNELS} == 1 ]]
then
  rm -f /home/i2pd/conf/tunnels.conf
else
  sed 's/\$IP_CONTAINER/'"${IP_CONTAINER}"'/g ; s/\$IP_BRIDGE/'"${IP_BRIDGE}"'/g ; s/\PORT_BACKEND/'"${PORT_BACKEND}"'/g ; s/\PORT_EXPOSED/'"${PORT_EXPOSED}"'/g' \
    /home/i2pd/conf/tunnels.org.conf >/home/i2pd/conf/tunnels.conf
fi

# overwrite resolv.conf - forces the container to use stubby as a resolver
cat </home/i2pd/network/resolv.conf >/etc/resolv.conf

# DNS-over-TLS, -C path to config
/usr/local/bin/stubby -l -C /home/i2pd/network/stubby.yml &

# see configs: /conf/i2pd.conf
su i2pd -c "/home/i2pd/bin/i2pd --datadir=/home/i2pd/data --conf=/home/i2pd/conf/i2pd.conf"
