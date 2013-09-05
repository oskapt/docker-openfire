#!/bin/bash

CONTAINER="monachus/openfire"

# Set this to "-d" to background the container.  
DAEMON=""

# File sharing proxy port
#FSPROXY="-p 7777:7777"

if [ ! -d $(pwd)/etc ] || [ ! -d $(pwd)/lib ]; then
    echo "Please run this from the 'run' directory to access the persistent volumes."
    exit 1
fi

docker run $DAEMON $FSPROXY -v $(pwd)/lib:/var/lib/openfire -v $(pwd)/etc:/etc/openfire $CONTAINER
