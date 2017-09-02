
export VANITYGEN_CONTRACT_ADDRESS=$(cat ~/iexecdev/iexec-node/poc/vanitygen/front/build/contracts/VanityGen.json | grep "address\":" | cut -d: -f2 | cut -d\" -f2)
echo "VANITYGEN_CONTRACT_ADDRESS is :$VANITYGEN_CONTRACT_ADDRESS"
echo "update address in ~/iexecdev/iexec-node/poc/vanitygen/bridge/vanitygen.js"
sed -i "s/.*var contract_address =.*/var contract_address =\"${VANITYGEN_CONTRACT_ADDRESS}\";/g" ~/iexecdev/iexec-node/poc/vanitygen/bridge/vanitygen.js

pm2 stop ~/iexecdev/iexec-node/poc/vanitygen/bridge/vanitygen.js
pm2 start ~/iexecdev/iexec-node/poc/vanitygen/bridge/vanitygen.js
