#!/bin/sh

NODE_DIR=/root/vpnsatoshi/.VPNSatoshi

echo "start for $NODE_NAME in $NODE_DIR directory"

if [ ! -f "$NODE_DIR/config/config.toml" ]; then
  echo "init config..."

  /usr/local/bin/vpnsatoshid --home $NODE_DIR init $NODE_NAME
  cp /usr/local/genesis/testnet.json $NODE_DIR/config/genesis.json
  /usr/local/bin/vpnsatoshid --home $NODE_DIR keys add $NODE_NAME --keyring-backend test
  nodeAddress=$(/usr/local/bin/vpnsatoshid --home $NODE_DIR keys show $NODE_NAME --keyring-backend test --address)

  /usr/local/bin/vpnsatoshid --home $NODE_DIR add-genesis-account $nodeAddress 1000000000000000uvpns
  /usr/local/bin/vpnsatoshid --home $NODE_DIR gentx $NODE_NAME 1000000000uvpns --gas 1000000 --gas-prices 0.1uvpns --keyring-backend test
  /usr/local/bin/vpnsatoshid --home $NODE_DIR collect-gentxs
  sed -i -e 's/laddr = "tcp:\/\/127.0.0.1:26657"/laddr = "tcp:\/\/0.0.0.0:26657"/' $NODE_DIR/config/config.toml
fi

if [ -n "$RPC_URL" ]; then
  echo "Start sync with external genesis..."
  sleep 10
  curl -s "$RPC_URL/genesis" | jq -r '.result.genesis' > $NODE_DIR/config/genesis.json

  responseJson=$(curl -s "$RPC_URL/status")
  rpcId=$(echo "$responseJson" | jq -r '.result.node_info.id')
  sed -i -e 's/seeds = ""/seeds = "'$rpcId'@'$P2P_URL'"/' $NODE_DIR/config/config.toml
fi

/usr/local/bin/vpnsatoshid --home $NODE_DIR $@