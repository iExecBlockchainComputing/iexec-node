rm -rf ./build
export NODE_ENV=development
truffle compile
truffle migrate --reset
rm -rf ./src/build/contracts
cp -rf ./build/contracts ./src/build/contracts

./node_modules/.bin/webpack --config ./config/webpack.config.dev.js 
#node ./scripts/test.js
#node ./script/build.js
pm2 start ./script/start.js
