
#Vagrant IEXEC DEV 


Let Vagrant build an Ubuntu machine with all the developer needs :
lib to compile, run, test xtremweb, git, python, truffle, web3, node, parity, geth, testrpc etc ...

###Prerequisite:

install Vagrant 1.9.7 on your machine 
install virtuabox 5.1.x on your machine 

###Mount your vm :
```
vagrant up
```
###connnect to your vm  :
```
vagrant ssh
```
### test your vm ok for xtremweb :
```
cd iexecdev/

git clone https://github.com/iExecBlockchainComputing/xtremweb-hep.git

cd xtremweb-hep/

git checkout testsrobotframework

cd test/robotframework/

pybot -d Results ./Tests/
```

Expected results 
Tests                                                                 | PASS |
14 critical tests, 14 passed, 0 failed
14 tests total, 14 passed, 0 failed
Output:  /home/vagrant/iexecdev/xtremweb-hep/test/robotframework/Results/output.xml
Log:     /home/vagrant/iexecdev/xtremweb-hep/test/robotframework/Results/log.html
Report:  /home/vagrant/iexecdev/xtremweb-hep/test/robotframework/Results/report.html


### initialize a truffle project
```
npm init

npm install truffle@3.4.7 --save-dev

./node_modules/.bin/truffle init
 
truffle compile
```
 
### test a truffle project on testrpc
run in another terminal (use tmux for instance)
```
testrpc
```
Then you can deploy and test on testrpc
```
truffle migrate
 
truffle test
```

### test a truffle project on a private network using geth
create a file ~iexecdev/password.txt

```
cd gethUtils/
./init42.sh
```
create some accounts 
```
./createAccounts42.sh 5
```
run in another terminal (use tmux for instance)
```
./miner42.sh
```
first time you have to wait for DAG creation : Generating DAG in progress
when miner start you will see :🔨 mined potential block

unlockAccounts for your test if needed
```
./unlockAccounts42.sh
```
Then you can return to your truffle project deploy and test on your local geth ethereum net 42
```
truffle migrate
 
truffle test
```

if your miner42.sh do not mine and is is stuck.
Clear your chain by removing 
/home/vagrant/iexecdev/.ethereum/net42/geth/chaindata
and /home/vagrant/iexecdev/.ethereum/net42/geth/lightchaindata
and try again. by removing thoses files you will lost all your previous work on your local chain.

### create a simple web GUI on a truffle project
in /home/vagrant/iexecdev :
``` 
mkdir simplegui

cd simplegui

npm init

npm install truffle@3.4.7 --save-dev

./node_modules/.bin/truffle init
 
truffle compile

mkdir -p app/js

touch app/index.html

```
In ./app/index.html, add :
```
<!doctype html>
<html lang="en" dir="ltr">
<head>
<title>Transfer MetaCoins</title>
<meta charset="utf-8">
</head>
<body>
<div>You have <span id="balance">Loading...</span> MetaCoins</div>
<div id="status"></div>

<script src="js/app.js"></script>
</body>
</html>
```

```
npm install web3@0.18.4 truffle-contract@2.0.0 bluebird jquery --save
npm install webpack --save-dev
npm install file-loader --save-dev
touch app/js/app.js
```

in ./app/js/app.js

```
const Web3 = require("web3");
const Promise = require("bluebird");
const truffleContract = require("truffle-contract");
const $ = require("jquery");
// Not to forget our built contract
const metaCoinJson = require("../../build/contracts/MetaCoin.json");

require("file-loader?name=../index.html!../index.html");

// Supports Mist, and other wallets that provide 'web3'.
if (typeof web3 !== 'undefined') {
    // Use the Mist/wallet/Metamask provider.
    window.web3 = new Web3(web3.currentProvider);
} else {
    // Your preferred fallback.
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545')); 
}

Promise.promisifyAll(web3.eth, { suffix: "Promise" });


const MetaCoin = truffleContract(metaCoinJson);
MetaCoin.setProvider(web3.currentProvider);

window.addEventListener('load', function() {
    return web3.eth.getAccountsPromise()
        .then(accounts => {
            if (accounts.length == 0) {
                $("#balance").html("N/A");
                throw new Error("No account with which to transact");
            }
            window.account = accounts[0];
            return MetaCoin.deployed();
        })
        .then(deployed => deployed.getBalance.call(window.account))
        .then(balance => $("#balance").html(balance.toString(10)))
        .catch(console.error);
});

```

create webpack.config.js with :
```
module.exports = {
    entry: "./app/js/app.js",
    output: {
        path: __dirname + "/build/app/js",
        filename: "app.js"
    },
    module: {
        loaders: []
    }
};
```

launch your testrpc or start your geth node with the cmd : 

```
testrpc

or 

./mine42externalexposed.sh

```


```
rm -rf ./build
./node_modules/.bin/truffle compile
./node_modules/.bin/truffle migrate --reset
./node_modules/.bin/webpack
php -S 0.0.0.0:8000 -t ./build/app
```

check you 10,000 MetaCoins on http://127.0.0.1:8000.
(with no metamask active so prefere on firefox)

### test a truffle project on a private network using parity
  TODO

* next to test/come : stockfish on your local vagrant vm (with local private net ethereum)
* next to test/come : vanitygen v2 on your local vagrant vm
* next to test/come : new bridge api solidy on your local vagrant vm
