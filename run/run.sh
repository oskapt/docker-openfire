#!/bin/bash

CONTAINER="docker.monach.us/openfire"

# Uncomment this to background the container
DAEMON="-d"

# File sharing proxy port
PORTS="-p 7777:7777 -p 5222:5222 -p 9091:9091 -p 5269:5269 -p :9999"

if [ ! -d $(pwd)/etc ] || [ ! -d $(pwd)/lib ]; then
    echo "Please run this from the 'run' directory to access the persistent volumes."
    exit 1
fi

docker run $DAEMON $PORTS -name openfire -v $(pwd)/lib:/var/lib/openfire -v $(pwd)/etc:/etc/openfire $CONTAINER
