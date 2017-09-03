./init42.sh
numberOfAccounts=$1
if [ "$(echo $numberOfAccounts | grep "^[ [:digit:] ]*$")" ]
then
    for n in $(seq $numberOfAccounts)
    do
        echo "create account $n"
        geth --datadir ~/iexecdev/.ethereum/net42 --networkid 42 --rpc --rpcport 8545 --rpcaddr 127.0.0.1 --rpccorsdomain "*" --rpcapi "eth,web3" --password ~/iexecdev/password.txt  account new
    done
     exit 0
else
    echo "you must give the number of accounts you want to create. example : ./createAccounts42.sh 5"
    exit 1
fi

