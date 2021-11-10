#!/usr/bin/env bash
#
# Author/Maintainer: konrad@diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/../"
cd ${PROJECT_PATH}

sudo docker build --force-rm --no-cache -t divax/i2p:latest .
sudo docker volume create i2pd-build
sudo docker volume create i2pd-data
sudo docker run \
  -d \
  --mount type=volume,src=i2pd-build,dst=/home/i2pd/ \
  --mount type=volume,src=i2pd-data,dst=/home/i2pd/data \
  --name i2pd-build divax/i2p:latest

# update certs
rm -R certificates
sudo cp -r -f /var/lib/docker/volumes/i2pd-build/_data/data/certificates ./certificates
sudo chown -R --reference ./ certificates

# update changelog & license
sudo cp -r -f /var/lib/docker/volumes/i2pd-build/_data/ChangeLog ./ChangeLog-i2pd
sudo cp -r -f /var/lib/docker/volumes/i2pd-build/_data/LICENSE ./LICENSE-i2pd

# clean up
sudo docker stop i2pd-build
sudo docker rm i2pd-build
sudo docker volume rm i2pd-build
sudo docker volume rm i2pd-data
