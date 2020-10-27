#!/usr/bin/env bash
#
# Author/Maintainer: konrad@diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

get_free_port () {
  STR=$(cat /proc/sys/net/ipv4/ip_local_port_range)
  LOWERPORT=`echo ${STR%[[:blank:]]*} | awk '{$1=$1}1'`
  UPPERPORT=`echo ${STR#${LOWERPORT}} | awk '{$1=$1}1'`

  while :
  do
          FREE_PORT="`shuf -i ${LOWERPORT}-${UPPERPORT} -n 1`"
          ss -lpn | grep -q ":${FREE_PORT} " || break
  done
}

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${PROJECT_PATH}/../

# @TODO replace environment variables with arguments, like: run.sh --name=my-i2pd
ENABLE_TUNNELS=${ENABLE_TUNNELS:-0}
TUNNELS_DIR=${TUNNELS_DIR:-${PWD}/tunnels.conf.d}

IP_BIND=${IP_BIND:-127.0.0.1}
VOLUME_PERSISTENCE=${VOLUME_PERSISTENCE:-0}

# HTTP daemon, serving the proxy.pac files
PORT_HTTP=${PORT_HTTP:-8080}

EXPOSE_PORT_DEFAULTS=${EXPOSE_PORT_DEFAULTS:-0}
if [[ ${EXPOSE_PORT_DEFAULTS} > 0 ]]
then
  PORT_WEBCONSOLE=${PORT_WEBCONSOLE:-7070}
  PORT_HTTP_PROXY=${PORT_HTTP_PROXY:-4444}
  PORT_SOCKS_PROXY=${PORT_SOCKS_PROXY:-4445}
  PORT_TOR=${PORT_TOR:-9050}
else
  PORT_WEBCONSOLE=${PORT_WEBCONSOLE:-0}
  PORT_SOCKS_PROXY=${PORT_SOCKS_PROXY:-0}

  FREE_PORT=0 ; get_free_port
  PORT_TOR=${PORT_TOR:-${FREE_PORT}}
  FREE_PORT=0 ; get_free_port
  PORT_HTTP_PROXY=${PORT_HTTP_PROXY:-${FREE_PORT}}
fi

NAME=${NAME:-i2pd-`date -u +%s`}

# assemble container run command
CMD="docker run\
 -d\
 --env ENABLE_TUNNELS=${ENABLE_TUNNELS}\
 --env PORT_TOR=${PORT_TOR}\
 --env PORT_HTTP_PROXY=${PORT_HTTP_PROXY}\
 -p ${IP_BIND}:${PORT_WEBCONSOLE}:7070\
 -p ${IP_BIND}:${PORT_HTTP_PROXY}:4444\
 -p ${IP_BIND}:${PORT_TOR}:9050\
 -p ${IP_BIND}:${PORT_HTTP}:8080"

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

if [[ ${PORT_SOCKS_PROXY} > 0 ]]
then
  CMD="${CMD} -p ${IP_BIND}:${PORT_SOCKS_PROXY}:4445"
fi

CMD="${CMD} --name ${NAME} divax/i2p:i2p-tor-stubby"

# run container
echo "Executing: ${CMD}"
${CMD}
