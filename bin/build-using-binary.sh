#!/usr/bin/env bash
#
# Author/Maintainer: konrad@diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/../"
cd ${PROJECT_PATH}

TAG=${TAG:-current-i2p-tor}

sudo docker build --force-rm --no-cache -t divax/i2p:${TAG} -f Dockerfile-binary ./
