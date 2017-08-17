./init42.sh
if [ "$#" -ne 1 ]; then
    echo "usage: ./giveMeFive42.sh address "
    exit 1
fi
geth --exec "eth.sendTransaction({from:eth.coinbase, to:\"$1\", value: web3.toWei(5, \"ether\")})" attach ipc:/home/vagrant/iexecdev/.ethereum/net42/geth.ipc