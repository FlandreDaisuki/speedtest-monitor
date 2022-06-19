#!/bin/bash

docker run --rm -it \
  -v "$(pwd):/root" \
  tianon/speedtest
