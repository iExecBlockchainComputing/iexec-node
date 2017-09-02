console.log("node giveMeFive.js toAddresstoSet");
const Web3 = require("web3");
web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

web3.eth.defaultAccount = web3.eth.accounts[0];
console.log("sending 5 ether from "+web3.eth.defaultAccount+" to "+process.argv[2]);
web3.eth.sendTransaction({from: web3.eth.defaultAccount, to:process.argv[2],value: web3.toWei(5,'ether')}, function(err, transactionHash) {
    if (!err)
        console.log(transactionHash); 
});
