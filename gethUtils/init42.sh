if [ -f ~/iexecdev/password.txt ]
then
    geth --datadir ~/.ethereum/net42 init ~/gethUtils/genesis42.json
    exit 0
else
    echo "~/iexecdev/password.txt file must exist "
    exit 1
fi