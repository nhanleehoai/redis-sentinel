#!/bin/bash

set -e

CONFIG="/tmp/redis-slave.conf"

# Generate the config only if it doesn't exist
if [[ ! -f $CONFIG ]]; then
    
	cp /tmp/redis.conf $CONFIG
    echo "slaveof $MASTER_HOST $MASTER_PORT" >> "$CONFIG"
	echo "slave-announce-ip $(hostname -i)" >> "$CONFIG"
    
fi

exec "$@"