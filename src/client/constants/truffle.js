import Web3 from 'web3';

import Vanity from '../../build/contracts/VanityGen.json';
import rlc from '../../build/contracts/RLC.json';

console.log(Vanity);
// const self = this;

// Get the RPC provider and setup our SimpleStorage contract.
// const provider = new Web3.providers.HttpProvider('http://localhost:8545');
let provider = null;
if (typeof web3 !== 'undefined') provider = new Web3(window.web3.currentProvider);
else provider = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
const contract = require('truffle-contract');

const VanityGen = contract(Vanity);
const RLC = contract(rlc);


RLC.setProvider(provider);
VanityGen.setProvider(provider);

// Get Web3 so we can get our accounts.
const web3RPC = provider;

// Declaring this for later so we can chain functions on SimpleStorage.
// let simpleStorageInstance;

// Get accounts.
web3RPC.eth.getAccounts((error, accounts) => {
  console.log(VanityGen);
  console.log(accounts);
  VanityGen.deployed().then((instance) => {
    const vanity = instance;
    console.log(`https://ropsten.etherscan.io/address/${vanity.address}`);
  });

  /* global web3 */
  VanityGen.deployed().then((instance) => {
    const myEvent = instance.Logs({ user: web3.eth.accounts[0] });
    myEvent.watch((err, result) => {
      if (err) {
        console.log('Erreur event ', err);
        return;
      } else if (result.args.status === 'Task finish!') {
        console.log(result.args.status);
      } else if (result.args.status === 'Invalid') {
        console.log('event invalid');
        console.log(result.args.status);
      } else if (result.args.status === 'Erreur') {
        console.log('event erreur');
        console.log(result.args.status);
      } else if (result.args.status === 'Running') {
        console.log(result.args.status);
      } else {
        console.log(`http://xw.iex.ec/xwdbviews/works.html?sSearch=${result.args.status}`);
        console.log('urllli ', result.args.status);
      }
      console.log('Parse ', result.args.status, result.args.user);
      // console.log("Event = ", JSON.parse(result.args.value));
    });
  });

  RLC.deployed().then((instance) => {
    console.log('rlc instance ', instance);
  });
});
