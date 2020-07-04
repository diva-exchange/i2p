#!/usr/bin/env bash

set -e

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${PROJECT_PATH}/../

# @TODO replace environment variables with arguments, like: run.sh --name=my-ip2d
ENABLE_TUNNELS=${ENABLE_TUNNELS:-0}
TUNNELS_DIR=${TUNNELS_DIR:-${PWD}/tunnels.conf.d}
PORT_WEBCONSOLE=${PORT_WEBCONSOLE:-7070}
PORT_HTTP_PROXY=${PORT_HTTP_PROXY:-4444}
PORT_SOCKS_PROXY=${PORT_SOCKS_PROXY:-4445}
NAME=${NAME:-i2pd}
NAME_VOLUME=${NAME_VOLUME:-i2pd}

# persistent data storage
docker volume create ${NAME_VOLUME}

# start the container
docker run \
  --env ENABLE_TUNNELS=${ENABLE_TUNNELS} \
  -v ${TUNNELS_DIR}:/home/i2pd/tunnels.source.conf.d/ \
  -v ${NAME_VOLUME}:/home/i2pd/ \
  -p ${PORT_WEBCONSOLE}:7070 \
  -p ${PORT_HTTP_PROXY}:4444 \
  -p ${PORT_SOCKS_PROXY}:4445 \
  -d \
  --name ${NAME} \
  divax/i2p:latest
