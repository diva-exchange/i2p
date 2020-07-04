#!/usr/bin/env bash

set -e

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${PROJECT_PATH}/../

ENABLE_TUNNELS=${ENABLE_TUNNELS:-0}

# persistent data storage
docker volume create i2pd

# start the container
docker run \
  --env ENABLE_TUNNELS=${ENABLE_TUNNELS} \
  -p 7070:7070 \
  -p 4444:4444 \
  -p 4445:4445 \
  -d \
  --name i2pd \
  -v ~/tunnels.conf.d:/home/i2pd/tunnels.source.conf.d/ \
  -v i2pd:/home/i2pd/ \
  divax/i2p:latest
