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
  rm -f ${TUNNELS_DIR}/*.conf

  [[ -f /home/i2pd/tunnels.source.conf.d/*.conf ]] && cp \
    /home/i2pd/tunnels.source.conf.d/*.conf ${TUNNELS_DIR}

  # replace environment variables in the tunnels config files
  if [[ -f ${TUNNELS_DIR}/*.conf ]]
  then
    for pathFile in ${TUNNELS_DIR}/*.conf
    do
      eval "echo \"$(cat ${pathFile})\"" >${pathFile}
    done
  fi
fi

# replace variables in the i2pd config files
sed \
  's!\$IP_CONTAINER!'"${IP_CONTAINER}"'!g ; s!\$IP_BRIDGE!'"${IP_BRIDGE}"'!g ; s!\$TUNNELS_DIR!'"${TUNNELS_DIR}"'!g' \
  /home/i2pd/conf/i2pd.org.conf >/home/i2pd/conf/i2pd.conf

# overwrite resolv.conf - forces the container to use dnscrypt as a resolver
cat </home/i2pd/network/resolv.conf >/etc/resolv.conf
dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -logfile /dev/null 2>&1 &

# see configs: /conf/i2pd.conf
su - i2pd
/home/i2pd/bin/i2pd --datadir=/home/i2pd/data --conf=/home/i2pd/conf/i2pd.conf
