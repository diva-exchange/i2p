#!/bin/sh
#
# Copyright (C) 2020 diva.exchange
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author/Maintainer: Konrad Bächler <konrad@diva.exchange>
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

ENABLE_TUNNELS=${ENABLE_TUNNELS:-0}
IP_BRIDGE=${IP_BRIDGE:-`ip route | awk '/default/ { print $3; }'`}

TUNNELS_DIR=/home/i2pd/tunnels.null
IP_CONTAINER=`ip route get 1 | awk '{ print $NF; exit; }'`

PORT_TOR=${PORT_TOR:?err}
PORT_HTTP_PROXY=${PORT_HTTP_PROXY:?err}

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

# replace variables in the proxy pac files
sed \
  's!\$PORT_TOR!'"${PORT_TOR}"'!g ; s!\$PORT_HTTP_PROXY!'"${PORT_HTTP_PROXY}"'!g' \
  /home/i2pd/htdocs/proxy.org.pac >/home/i2pd/htdocs/proxy.pac
sed \
  's!\$PORT_TOR!'"${PORT_TOR}"'!g ; s!\$PORT_HTTP_PROXY!'"${PORT_HTTP_PROXY}"'!g' \
  /home/i2pd/htdocs/proxy-ip2-onion-clearnet.org.pac >/home/i2pd/htdocs/proxy-ip2-onion-clearnet.pac

# overwrite resolv.conf - using specific DNS servers only to initially access reseed servers
cat </home/i2pd/network/resolv.conf >/etc/resolv.conf

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
su - i2pd
/home/i2pd/bin/i2pd --datadir=/home/i2pd/data --conf=/home/i2pd/conf/i2pd.conf
