#!/bin/bash

nohup geth --datadir ~/.ethereum/net1337  --networkid 1337 --ws --wsaddr "0.0.0.0" --wsorigins "*" --rpc --rpcport 8545 --rpcaddr "0.0.0.0" --rpccorsdomain "*" --rpcapi "eth,web3,net,personal" --mine --minerthreads 1 --unlock "0" --password password.txt &

echo sleep 10 sec
sleep 10

echo unlockAccount1
geth --exec "personal.unlockAccount(eth.accounts[1], 'whatever', 100000)" attach http://localhost:8545
echo unlockAccount2
geth --exec "personal.unlockAccount(eth.accounts[2], 'whatever', 100000)" attach http://localhost:8545
echo unlockAccount3
geth --exec "personal.unlockAccount(eth.accounts[3], 'whatever', 100000)" attach http://localhost:8545
echo unlockAccount4
geth --exec "personal.unlockAccount(eth.accounts[4], 'whatever', 100000)" attach http://localhost:8545
echo unlockAccount5
geth --exec "personal.unlockAccount(eth.accounts[5], 'whatever', 100000)" attach http://localhost:8545
echo unlockAccount6
geth --exec "personal.unlockAccount(eth.accounts[6], 'whatever', 100000)" attach http://localhost:8545
echo unlockAccount7
geth --exec "personal.unlockAccount(eth.accounts[7], 'whatever', 100000)" attach http://localhost:8545
echo unlockAccount8
geth --exec "personal.unlockAccount(eth.accounts[8], 'whatever', 100000)" attach http://localhost:8545
echo unlockAccount9
geth --exec "personal.unlockAccount(eth.accounts[9], 'whatever', 100000)" attach http://localhost:8545



FILES=/root/.ethereum/net1337/keystore/*
COUNTER=0
for f in $FILES
do
  pk=$(node ./extractPrivateKey.js $f)
  filename=$(echo "${COUNTER}_${pk}")
  touch /root/.ethereum/net1337/keystore/${filename}
  COUNTER=$[$COUNTER +1]
done


geth --exec "eth.sendTransaction({from:eth.accounts[0], to:eth.accounts[1], value: web3.toWei(5, 'ether')})" attach http://localhost:8545

geth attach http://localhost:8545


echo "LOCAL_GETH_WELL_INITIALIZED"

while true; do
 sleep 5
done