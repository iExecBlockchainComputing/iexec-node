./init42.sh
if [ -d ~/.ethash ]
then
        echo "clear ~/.ethash content"
        rm -rf ~/.ethash/*
fi
# 1 epoch = 30000
geth --datadir ~/iexecdev/.ethereum/net42 --networkid 42 --rpc --rpcport 8545 --rpcaddr 127.0.0.1 --rpccorsdomain "*" --rpcapi "eth,web3,net" --unlock 0 --password ~/iexecdev/password.txt makedag 30000 ~/.ethash
