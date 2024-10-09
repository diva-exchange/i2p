#!/usr/bin/env bash
#
# Author/Maintainer: DIVA.EXCHANGE Association, https://diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/../"
cd "${PROJECT_PATH}"

TAG=${TAG:-current}

sudo docker buildx build --force-rm --no-cache -t divax/i2p:"${TAG}" .
sudo docker volume create i2pd-build
sudo docker run \
  -d \
  --mount type=volume,src=i2pd-build,dst=/i2pd/ \
  --name i2pd-build divax/i2p:"${TAG}"

# update certs
rm -R certificates
sudo cp -r -f /var/lib/docker/volumes/i2pd-build/_data/data/certificates ./certificates
sudo chown -R --reference ./ certificates

# update changelog & license
sudo cp -r -f /var/lib/docker/volumes/i2pd-build/_data/ChangeLog ./ChangeLog-i2pd
sudo cp -r -f /var/lib/docker/volumes/i2pd-build/_data/LICENSE ./LICENSE-i2pd
sudo cp -r -f /var/lib/docker/volumes/i2pd-build/_data/bin/i2pd ./bin/i2pd
sudo chown --reference ./bin ./bin/i2pd
sudo chmod u+x ./bin/i2pd

# clean up
sudo docker stop i2pd-build
sudo docker rm i2pd-build
sudo docker volume rm i2pd-build
