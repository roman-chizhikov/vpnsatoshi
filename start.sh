export PROJECT_DIR=$HOME/vpnsatoshi

# Node names
export VALIDATOR_1_NAME=validator_1
export RPC_1_NAME=rpc_1
# Node directories
export VALIDATOR_1_DIR=$PROJECT_DIR/$VALIDATOR_1_NAME
export RPC_1_DIR=$PROJECT_DIR/$RPC_1_NAME


configNode() {
    nodeDir=$1
    nodeName=$2
    seeds=$3

    echo "start for $nodeName in $nodeDir directory, seeds: $seeds" >&2

    if test -f "$nodeDir/.VPNSatoshi/config/config.toml"; then
      echo "skip config" >&2
    else
      echo "init config..." >&2

      docker run -ti -v $nodeDir:/home/tendermint -v $PWD:/apps ignitehq/cli chain init
      sed -i -e "/moniker =/ s/= .*/= \"$nodeName\"/" $nodeDir/.VPNSatoshi/config/config.toml

      sed -i -e 's/seeds = ""/seeds = "'$seeds'"/' $nodeDir/.VPNSatoshi/config/config.toml
    fi

   
    # echo "copy genesis" >&2
    # cp ./genesis/testnet.json $nodeDir/.VPNSatoshi/config/genesis.json

    echo $(docker run -v $nodeDir:/root/vpnsatoshi vpnsatoshi:latest --home /root/vpnsatoshi/.VPNSatoshi tendermint show-node-id)
}

# Build node docker 
docker build ./ --tag vpnsatoshi:latest

# Config nodes
validatorId=$(configNode $VALIDATOR_1_DIR $VALIDATOR_1_NAME "")
configNode $RPC_1_DIR $RPC_1_NAME "$validatorId@validator_1:26656"

# Copy one genesis to all nodes
cp $VALIDATOR_1_DIR/.VPNSatoshi/config/genesis.json $RPC_1_DIR/.VPNSatoshi/config/genesis.json

# Run nodes
docker-compose up  --remove-orphans