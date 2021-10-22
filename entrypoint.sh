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

HAS_SAM=${HAS_SAM:-false}
IS_FLOODFILL=${IS_FLOODFILL:-false}
if [[ ${IS_FLOODFILL} == true ]]
then
  BANDWIDTH=${BANDWIDTH:-X}
else
  BANDWIDTH=${BANDWIDTH:-L}
fi

ENABLE_TUNNELS=${ENABLE_TUNNELS:-0}
IP_BRIDGE=${IP_BRIDGE:-`ip route | awk '/default/ { print $3; }'`}

IP_CONTAINER=`ip route get 1 | awk '{ print $NF; exit; }'`

if [[ ${ENABLE_TUNNELS} == 1 ]]
then
  TUNNELS_DIR_SOURCE=${TUNNELS_DIR_SOURCE:-/home/i2pd/tunnels.source.conf.d}
  [[ ! -d ${TUNNELS_DIR_SOURCE} ]] && mkdir -p ${TUNNELS_DIR_SOURCE}
  echo "Using tunnels source ${TUNNELS_DIR_SOURCE}"

  TUNNELS_DIR=/home/i2pd/tunnels.conf.d
  rm -f ${TUNNELS_DIR}/*.conf

  if [[ `ls ${TUNNELS_DIR_SOURCE}/*.conf >/dev/null 2>&1 ; echo $?` -eq 0 ]]
  then
    cp ${TUNNELS_DIR_SOURCE}/*.conf ${TUNNELS_DIR}/
    chown i2pd:i2pd ${TUNNELS_DIR}/*.conf
    chmod 0644 ${TUNNELS_DIR}/*.conf
  fi

  # replace environment variables in the tunnels config files
  for pathFile in `ls -1 ${TUNNELS_DIR}/*.conf 2>/dev/null`
  do
    eval "echo \"$(cat ${pathFile})\"" >${pathFile}
  done
else
  TUNNELS_DIR=/home/i2pd/tunnels.null
fi

# replace variables in the i2pd config files
sed \
  's!\$IP_CONTAINER!'"${IP_CONTAINER}"'!g ; s!\$IP_BRIDGE!'"${IP_BRIDGE}"'!g ; s!\$TUNNELS_DIR!'"${TUNNELS_DIR}"'!g ; s!\$HAS_SAM!'"${HAS_SAM}"'!g ; s!\$IS_FLOODFILL!'"${IS_FLOODFILL}"'!g ; s!\$BANDWIDTH!'"${BANDWIDTH}"'!g' \
  /home/i2pd/conf/i2pd.org.conf >/home/i2pd/conf/i2pd.conf

# overwrite resolv.conf - using specific DNS servers only to initially access reseed servers
cat </home/i2pd/network/resolv.conf >/etc/resolv.conf

# see configs: /conf/i2pd.conf
su - i2pd
/home/i2pd/bin/i2pd --datadir=/home/i2pd/data --conf=/home/i2pd/conf/i2pd.conf
