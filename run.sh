#!/usr/bin/env bash

docker run \
  -p 7070:7070 \
  -p 4444:4444 \
  -p 4445:4445 \
  -p 4446:4446 \
  -p 4447:4447 \
  -d \
  --name i2p0 divax/i2p

