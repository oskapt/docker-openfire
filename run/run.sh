#!/bin/bash

CONTAINER="monachus/openfire:4"
NAME="openfire"

# Uncomment this to background the container
DAEMON="-d"

# File sharing proxy port
PORTS="-p 7777:7777 -p 5222:5222 -p 9091:9091 -p 5269:5269 -p 9090:9090"

if [ ! -d $(pwd)/security ] || [ ! -d $(pwd)/conf ]; then
    echo "Please run this from the 'run' directory to access the persistent volumes."
    exit 1
fi

docker run $DAEMON $PORTS --name $NAME \
  -v $(pwd)/conf:/usr/share/openfire/conf \
  -v $(pwd)/security:/usr/share/openfire/resources/security \
  -v $(pwd)/embedded-db:/usr/share/openfire/embedded-db \
  -v $(pwd)/plugins:/usr/share/openfire/plugins \
  $CONTAINER
