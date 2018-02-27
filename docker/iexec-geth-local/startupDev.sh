#!/bin/bash



nohup geth --dev --ws --wsaddr "0.0.0.0" --wsorigins "*" --rpc --rpcport 8545 --rpcaddr "0.0.0.0" --rpccorsdomain "*" --rpcapi "eth,web3,net,personal" &



while true; do
 sleep 5
done