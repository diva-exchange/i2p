#!/usr/bin/env bash

set -e

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${PROJECT_PATH}/../

docker run \
  -p 7070:7070 \
  -p 4444:4444 \
  -p 4445:4445 \
  -p 9050:9050 \
  -p 8080:8080 \
  -d \
  --name i2pd \
  divax/i2p:i2p-tor-proxy
