#!/usr/bin/env bash

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${PROJECT_PATH}

docker build -f Dockerfile-Build-alpine --no-cache --tag diva/i2pd:build ${PROJECT_PATH}

docker run -d --volume i2pd_build:/home/i2pd/ --name i2pd-build diva/i2pd:build

cp -f /var/lib/docker/volumes/i2pd_build/_data/i2pd-x86_64-alpine ${PROJECT_PATH}/bin/
cp -f /var/lib/docker/volumes/i2pd_build/_data/LICENSE ${PROJECT_PATH}/bin/
cp -f /var/lib/docker/volumes/i2pd_build/_data/ChangeLog ${PROJECT_PATH}/bin/
chown -R --reference=${PROJECT_PATH} ${PROJECT_PATH}/bin
echo "Copied new i2pd binary, LICENSE and ChangeLog to ${PROJECT_PATH}/bin/"

rm -R ${PROJECT_PATH}/i2pd_certs/
cp -fr /var/lib/docker/volumes/i2pd_build/_data/certificates/ ${PROJECT_PATH}/i2pd_certs/
chown -R --reference=${PROJECT_PATH} ${PROJECT_PATH}/i2pd_certs
echo "Copied certificates to ${PROJECT_PATH}/i2pd_certs/"

docker stop i2pd-build
docker rm i2pd-build
docker volume rm i2pd_build
docker rmi diva/i2pd:build

docker build -f Dockerfile --no-cache --tag divax/i2p:latest ${PROJECT_PATH}
