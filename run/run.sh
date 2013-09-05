#!/bin/bash

if [ ! -d $(pwd)/etc ] || [ ! -d $(pwd)/lib ]; then
    echo "Please run this from the 'run' directory to access the persistent volumes."
    exit 1
fi

docker run -d -v $(pwd)/lib:/var/lib/openfire -v $(pwd)/etc:/etc/openfire monachus/openfire
