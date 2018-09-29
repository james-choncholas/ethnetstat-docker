#!/bin/bash
set -ex

cd /opt/eth-net-intelligence-api
sed -i "s/RPC_HOST_IP/${RPC_HOST_IP}/g" ./app.json
echo "exec pm2-docker start app.json"
exec pm2-docker start app.json &

sleep 1

cd /opt/eth-netstats
export WS_SECRET=internal-to-this-container
echo "npm start"
npm start
