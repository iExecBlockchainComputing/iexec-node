
if [ ! -f ~/iexecdev/password.txt ]
then
 	echo " you must create a ~/iexecdev/password.txt file to continue" 	
	exit 1
fi

echo "kill existing geth process"
./killGeth.sh

sleep 5

#clear existing chain42
if [ -d ~/iexecdev/.ethereum/net42/ ]
then
	echo "clear ~/iexecdev/.ethereum/net42/ content"
	rm -rf ~/iexecdev/.ethereum/net42/*
fi
# create a new DAG too 
if [ -d ~/.ethash ]
then
 	echo "clear ~/.ethash content"
 	rm -rf ~/.ethash/* 
fi
echo "creating 10 accounts"
./createAccounts42.sh 10

# do not want DAG epoch 1 creation to slow down mining so create it before starting miner
echo "create DAG epoch 1"
./makedag42.sh

echo "start a coinbase miner in background" 
./mine42background.sh
sleep 5

while [ $( ./getBlockNumber42.sh | grep -v Fatal | grep -v INFO ) -lt 45 ]
do
echo "wait for 45 mined blocks"
sleep 10
done

echo "45 blocks mined in geth 42 !"

echo "unlocked 9 accounts"
./unlockAccounts42.sh 9


echo "local geth 42 ready to go for testing"

