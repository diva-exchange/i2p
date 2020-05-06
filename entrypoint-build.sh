#!/bin/sh
#
# Author/Maintainer: konrad@diva.exchange
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

mkdir -p /tmp/gitclone \
  && cd /tmp/gitclone \
  && git clone -b openssl https://github.com/PurpleI2P/i2pd.git \
  && cd i2pd/build \
  && cmake . \
  && make \
  && mv i2pd /home/i2pd/i2pd-x86_64-alpine \
  && chmod u+x /home/i2pd/i2pd-x86_64-alpine \
  && cd /tmp/gitclone/i2pd/contrib \
  && cp -r certificates /home/i2pd/certificates \
  && cd /tmp/gitclone/i2pd/ \
  && cp LICENSE /home/i2pd/ \
  && cp ChangeLog /home/i2pd/ \
  && rm -R /tmp/gitclone
