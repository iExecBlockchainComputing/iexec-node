
rm -rf ./build
./node_modules/.bin/truffle compile
./node_modules/.bin/truffle migrate --reset

export STOCKFISH_CONTRACT_ADDRESS=$(cat ~/iexecdev/bridge_stockfish/build/contracts/stockfish.json | grep "address\":" | cut -d: -f2 | cut -d\" -f2)
echo "STOCKFISH_CONTRACT_ADDRESS is :$STOCKFISH_CONTRACT_ADDRESS"
echo "update address in ~/iexecdev/bridge_stockfish/app/js/app.js"
sed -i "s/.*var contract_address =.*/var contract_address =\"${STOCKFISH_CONTRACT_ADDRESS}\";/g" ~/iexecdev/bridge_stockfish/app/js/app.js
echo "update address in ~/iexecdev/bridge_stockfish/stockfishback/stockfish.js"
sed -i "s/.*var contract_address =.*/var contract_address =\"${STOCKFISH_CONTRACT_ADDRESS}\";/g" ~/iexecdev/bridge_stockfish/stockfishback/stockfish.js

./node_modules/.bin/truffle build

pm2 stop ~/iexecdev/bridge_stockfish/stockfishback/stockfish.js
pm2 start ~/iexecdev/bridge_stockfish/stockfishback/stockfish.js


php -S 0.0.0.0:8000 -t ./build/app
