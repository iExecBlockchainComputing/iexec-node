./init42.sh
numberOfAccounts=$1
passwd=$(cat ~/iexecdev/password.txt)
if [ "$(echo $numberOfAccounts | grep "^[ [:digit:] ]*$")" ]
then
    for n in $(seq $numberOfAccounts)
    do
        echo "unlock account $n"
        geth --exec "personal.unlockAccount(eth.accounts[$n], '$passwd', 100000)" attach ipc:/home/vagrant/.ethereum/net42/geth.ipc
     done
     exit 0
else
    echo "you must give the number of accounts you want to unlock. example : ./unlockAccounts42.sh 5"
    exit 1
fi






