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

ENABLE_HTTPPROXY=${ENABLE_HTTPPROXY:-0}
if [[ ${ENABLE_HTTPPROXY} == 1 ]]
then
  ENABLE_HTTPPROXY=true
else
  ENABLE_HTTPPROXY=false
fi
PORT_HTTPPROXY=${PORT_HTTPPROXY:-4444}

ENABLE_SOCKSPROXY=${ENABLE_SOCKSPROXY:-0}
if [[ ${ENABLE_SOCKSPROXY} == 1 ]]
then
  ENABLE_SOCKSPROXY=true
else
  ENABLE_SOCKSPROXY=false
fi
PORT_SOCKSPROXY=${PORT_SOCKSPROXY:-4445}

ENABLE_SAM=${ENABLE_SAM:-0}
if [[ ${ENABLE_SAM} == 1 ]]
then
  ENABLE_SAM=true
else
  ENABLE_SAM=false
fi
PORT_SAM=${PORT_SAM:-7656}

ENABLE_FLOODFILL=${ENABLE_FLOODFILL:-0}
if [[ ${ENABLE_FLOODFILL} == 1 ]]
then
  ENABLE_FLOODFILL=true
  BANDWIDTH=${BANDWIDTH:-X}
else
  ENABLE_FLOODFILL=false
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

# create a copy of the i2pd config file
cp /home/i2pd/conf/i2pd.org.conf /home/i2pd/conf/i2pd.conf
# replace variables in the i2pd config files
sed -i 's!\$IP_CONTAINER!'"${IP_CONTAINER}"'!g' /home/i2pd/conf/i2pd.conf
sed -i 's!\$IP_BRIDGE!'"${IP_BRIDGE}"'!g' /home/i2pd/conf/i2pd.conf
sed -i 's!\$TUNNELS_DIR!'"${TUNNELS_DIR}"'!g' /home/i2pd/conf/i2pd.conf
sed -i 's!\$ENABLE_HTTPPROXY!'"${ENABLE_HTTPPROXY}"'!g' /home/i2pd/conf/i2pd.conf
sed -i 's!\$PORT_HTTPPROXY!'"${PORT_HTTPPROXY}"'!g' /home/i2pd/conf/i2pd.conf
sed -i 's!\$ENABLE_SOCKSPROXY!'"${ENABLE_SOCKSPROXY}"'!g' /home/i2pd/conf/i2pd.conf
sed -i 's!\$PORT_SOCKSPROXY!'"${PORT_SOCKSPROXY}"'!g' /home/i2pd/conf/i2pd.conf
sed -i 's!\$ENABLE_SAM!'"${ENABLE_SAM}"'!g' /home/i2pd/conf/i2pd.conf
sed -i 's!\$PORT_SAM!'"${PORT_SAM}"'!g' /home/i2pd/conf/i2pd.conf
sed -i 's!\$ENABLE_FLOODFILL!'"${ENABLE_FLOODFILL}"'!g' /home/i2pd/conf/i2pd.conf
sed -i 's!\$BANDWIDTH!'"${BANDWIDTH}"'!g' /home/i2pd/conf/i2pd.conf

# overwrite resolv.conf - using specific DNS servers only to initially access reseed servers
cat </home/i2pd/network/resolv.conf >/etc/resolv.conf

# see configs: /conf/i2pd.conf
su - i2pd
/home/i2pd/bin/i2pd --datadir=/home/i2pd/data --conf=/home/i2pd/conf/i2pd.conf
