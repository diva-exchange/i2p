#!/usr/bin/env bash

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $PROJECT_PATH

docker build -f Dockerfile-Build --no-cache --tag diva/i2pd:build ${PROJECT_PATH}

docker run -d --volume i2pd_build:/home/i2pd/ --name i2pd-build diva/i2pd:build

cp -f /var/lib/docker/volumes/i2pd_build/_data/i2pd-x86_64-aesni ${PROJECT_PATH}/bin/
echo "Copied new i2pd binary to ${PROJECT_PATH}/bin/i2pd-x86_64-aesni"

docker stop i2pd-build
docker rm i2pd-build
docker volume rm i2pd_build
docker rmi diva/i2pd:build
