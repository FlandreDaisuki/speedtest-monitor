#!/bin/bash

docker run --rm -it \
  -v "$(pwd)/ookla:/root/.config/ookla" \
  tianon/speedtest
