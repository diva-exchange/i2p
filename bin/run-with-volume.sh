#!/usr/bin/env bash

set -e

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${PROJECT_PATH}/../

# persistent data storage
docker volume create i2pd

# start the container
docker run \
  -p 7070:7070 \
  -p 4444:4444 \
  -p 4445:4445 \
  -d \
  --name i2pd \
  --mount type=volume,src=i2pd,dst=/home/i2pd/ \
  divax/i2p:latest
