
rm -rf ./build
./node_modules/.bin/truffle compile
./node_modules/.bin/truffle migrate --reset

export STOCKFISH_CONTRACT_ADDRESS=$(cat ~/iexecdev/iexec-node/poc/stockfish/front/build/contracts/stockfish.json | grep "address\":" | cut -d: -f2 | cut -d\" -f2)
echo "STOCKFISH_CONTRACT_ADDRESS is :$STOCKFISH_CONTRACT_ADDRESS"
echo "update address in ~/iexecdev/iexec-node/poc/stockfish/front/app/js/app.js"
sed -i "s/.*var contract_address =.*/var contract_address =\"${STOCKFISH_CONTRACT_ADDRESS}\";/g" ~/iexecdev/iexec-node/poc/stockfish/front/app/js/app.js
echo "update address in ~/iexecdev/iexec-node/poc/stockfish/bridge/stockfish.js"
sed -i "s/.*var contract_address =.*/var contract_address =\"${STOCKFISH_CONTRACT_ADDRESS}\";/g" ~/iexecdev/iexec-node/poc/stockfish/bridge/stockfish.js

./node_modules/.bin/truffle build

cd ~/iexecdev/iexec-node/poc/stockfish/bridge
npm install
cd -
pm2 stop ~/iexecdev/iexec-node/poc/stockfish/bridge/stockfish.js
pm2 start ~/iexecdev/iexec-node/poc/stockfish/bridge/stockfish.js


php -S 0.0.0.0:8000 -t ./build/app
