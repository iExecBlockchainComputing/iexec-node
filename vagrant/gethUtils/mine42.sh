init42.sh
geth --datadir ~/iexecdev/.ethereum/net42 --networkid 42 --rpc --rpcport 8545 --rpcaddr 127.0.0.1 --rpccorsdomain "*" --rpcapi "eth,web3,net" --mine --minerthreads 4 --unlock 0 --password ~/iexecdev/password.txt --verbosity 3 console
