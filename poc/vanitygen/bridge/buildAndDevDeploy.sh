
export VANITYGEN_CONTRACT_ADDRESS=$(cat ~/iexecdev/vanitygen/build/contracts/VanityGen.json | grep "address\":" | cut -d: -f2 | cut -d\" -f2)
echo "VANITYGEN_CONTRACT_ADDRESS is :$VANITYGEN_CONTRACT_ADDRESS"
echo "update address in ~/iexecdev/bridge_vanity/vanitygen.js"
sed -i "s/.*var contract_address =.*/var contract_address =\"${VANITYGEN_CONTRACT_ADDRESS}\";/g" ~/iexecdev/bridge_vanity/vanitygen.js

pm2 stop ~/iexecdev/bridge_vanity/vanitygen.js
pm2 start ~/iexecdev/bridge_vanity/vanitygen.js
