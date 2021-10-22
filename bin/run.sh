#!/usr/bin/env bash
#
# Author/Maintainer: konrad@diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${PROJECT_PATH}/../

# @TODO replace environment variables with arguments, like: run.sh --name=my-i2pd
ENABLE_TUNNELS=${ENABLE_TUNNELS:-0}
TUNNELS_DIR=${TUNNELS_DIR:-${PWD}/tunnels.conf.d}

HAS_SAM=${HAS_SAM:-false}
IS_FLOODFILL=${IS_FLOODFILL:-false}
if [[ ${IS_FLOODFILL} == true ]]
then
  BANDWIDTH=${BANDWIDTH:-X}
else
  BANDWIDTH=${BANDWIDTH:-L}
fi

IP_BIND=${IP_BIND:-127.0.0.1}
VOLUME_PERSISTENCE=${VOLUME_PERSISTENCE:-0}
PORT_WEBCONSOLE=${PORT_WEBCONSOLE:-0}

EXPOSE_PORT_DEFAULTS=${EXPOSE_PORT_DEFAULTS:-0}
if [[ ${EXPOSE_PORT_DEFAULTS} > 0 ]]
then
  PORT_HTTP_PROXY=${PORT_HTTP_PROXY:-4444}
  PORT_SOCKS_PROXY=${PORT_SOCKS_PROXY:-4445}
  PORT_SAM=${PORT_SAM:-7656}
else
  PORT_HTTP_PROXY=${PORT_HTTP_PROXY:-0}
  PORT_SOCKS_PROXY=${PORT_SOCKS_PROXY:-0}
  PORT_SAM=${PORT_SAM:-0}
fi

NAME=${NAME:-i2pd-`date -u +%s`}

# assemble container run command
CMD="docker run\
 -d\
 --env ENABLE_TUNNELS=${ENABLE_TUNNELS}\
 --env HAS_SAM=${HAS_SAM}\
 --env IS_FLOODFILL=${IS_FLOODFILL}\
 --env BANDWIDTH=${BANDWIDTH}\
 -p ${IP_BIND}:${PORT_WEBCONSOLE}:7070"

# tunnels bind mount
if [[ ${ENABLE_TUNNELS} > 0 ]]
then
  CMD="${CMD} -v ${TUNNELS_DIR}:/home/i2pd/tunnels.source.conf.d/"
fi

# create persistent volume
if [[ ${VOLUME_PERSISTENCE} > 0 ]]
then
  docker volume create ${NAME}
  CMD="${CMD} -v ${NAME}:/home/i2pd/"
fi

if [[ ${PORT_HTTP_PROXY} > 0 ]]
then
  CMD="${CMD} -p ${IP_BIND}:${PORT_HTTP_PROXY}:4444"
fi
if [[ ${PORT_SOCKS_PROXY} > 0 ]]
then
  CMD="${CMD} -p ${IP_BIND}:${PORT_SOCKS_PROXY}:4445"
fi
if [[ ${PORT_SAM} > 0 ]]
then
  CMD="${CMD} -p ${IP_BIND}:${PORT_SAM}:7656"
fi

CMD="${CMD} --name ${NAME} divax/i2p:latest"

# run container
echo "Executing: sudo ${CMD}"
sudo ${CMD}
