#!/bin/bash

# Starts a local ethereum network status monitor
# similar to https://ethstats.net/
# Must be running on the same host running geth.
# Geth must have it's http rpc port 8545 open.
#
#   Note: since ethnetstats is running on the same
#   machine as geth RPC server, the RPC ports (8545/6)
#   have been taken by geth. Also, the mist container
#   might be using port 8540 Map around it with
#   port 8541.

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
MYIP=$(hostname -I | awk '{print $1}')

# stop old container
if [ "$(sudo docker ps -q -f name=ethnetstat)" ]; then
    echo "cleaning up ethnetstat container"
    sudo docker stop ethnetstat -t0
    sudo docker rm $(sudo docker ps --filter=status=exited --filter=status=created -q)
fi

if [ "$(sudo docker ps -q -f name=geth)" ]; then
    echo "geth is running on this machine"
else
    echo "geth container must be running on this host"
    exit 1
fi

# Start geth making the RPC port accessible to the network
sudo docker run -d --rm \
    --name ethnetstat \
    -p 3000:3000 \
    -p 8541:8545 \
    -e RPC_HOST_IP=$MYIP \
    ethnetstat

