import Web3 from 'web3';

import faucet from '../../build/contracts/Faucet.json';

const contract = require('truffle-contract');


// Get the RPC provider and setup our SimpleStorage contract.
const getRlc = () => {
  const provider = new Web3.providers.HttpProvider('http://localhost:8545');

  const Faucet = contract(faucet);
  Faucet.setProvider(provider);

  console.log(Faucet);
  // Get Web3 so we can get our accounts.
  const web3RPC = new Web3(provider);

  // Declaring this for later so we can chain functions on SimpleStorage.
  // let simpleStorageInstance;

  // Get accounts.
  web3RPC.eth.getAccounts((error, accounts) => {
    Faucet.deployed().then((instance) => {
      instance
        .gimmeFive({ gas: 200000, from: accounts[0] })
        .then((result) => {
          console.log(`result faucet = ${result}`);
        })
        .catch((e) => {
          console.log(`e ${e}`);
        });
    });
  });
};

export default getRlc;
