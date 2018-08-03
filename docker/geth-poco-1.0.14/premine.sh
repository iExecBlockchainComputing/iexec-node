#!/bin/bash
geth --datadir node1/ init devnet.json

nohup geth --datadir node1/ --rpc --rpcaddr '0.0.0.0' --rpcport 8545 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --networkid 1337 --gasprice '1' --unlock '1fa8602668d4bda4f45a25c8def0a619499457db,8bd535d49b095ef648cd85ea827867d358872809,70a1bebd73aef241154ea353d6c8c52d420d4f5b, 55b541c70252aa3eb1581b8e74ce1ec17126b33a, 9f1c94f78d7e95647a070acbee34d83836552dab, 474502e32df734afb087692d306a13ef72ff68a1, 56cb96342b7a3045934894bd72ddcf330ecc4108' --password node1/password.txt --mine &

sleep 2

cd PoCo && git checkout tags/1.0.14 && npm install && rm -R deployed/ && ./node_modules/.bin/truffle migrate && cd ..

geth --exec 'loadScript("/giveRlc.js"); giveRlc("0x091233035dcb12ae5a4a4b7fb144d3c5189892e1")' attach http://127.0.0.1:8545

pkill -INT geth

sleep 10