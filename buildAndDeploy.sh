
rm -rf ./build
./node_modules/.bin/truffle compile
./node_modules/.bin/truffle migrate --reset
./node_modules/.bin/truffle build
php -S 0.0.0.0:8000 -t ./build
