const Web3 = require("web3");
web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

web3.eth.sign(
    web3.eth.accounts[0],
    "0x0000000000000000000000000000000000000000000000000000000000000000");

console.log("web3.eth.accounts[0] is unlocked");