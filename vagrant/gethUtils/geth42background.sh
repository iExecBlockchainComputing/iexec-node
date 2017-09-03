rm -f ~/iexecdev/geth42background.log
./init42.sh
nohup geth --datadir ~/iexecdev/.ethereum/net42 --networkid 42 --rpc --rpcport 8545 --rpcaddr 127.0.0.1 --rpccorsdomain "*" --rpcapi "eth,web3,net" --unlock 0 --password ~/iexecdev/password.txt >~/iexecdev/geth42background.log 2>&1 & 
