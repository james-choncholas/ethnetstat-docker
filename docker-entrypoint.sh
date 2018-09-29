#!/bin/bash
set -ex

cd /opt/eth-net-intelligence-api
sed -i "s/RPC_HOST_IP/${RPC_HOST_IP}/g" ./app.json
exec pm2-docker start app.json

cd /opt/eth-netstats
export WS_SECRET=internal-to-this-container
npm start
