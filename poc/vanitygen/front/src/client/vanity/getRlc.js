/* global web3 */
import Web3 from 'web3';
import faucet from '../../build/contracts/Faucet.json';
import { getSmartContractAddressByJsonNetworks } from '../vanity/utils';

const getRlc = () => {
  if (window.web3.eth.accounts[0]) {
    let provider = null;

    if (typeof web3 !== 'undefined') provider = new Web3(window.web3.currentProvider);
    else provider = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

    const faucetContract = web3.eth.contract(faucet.abi);
    //  const faucetInstance = faucetContract.at('0x56b174d90e1704a86cc8b0a1780633217c096903');
    const faucetInstance = faucetContract.at(
        getSmartContractAddressByJsonNetworks(faucet.networks));
    provider.eth.getAccounts((error, accounts) => {
      faucetInstance
        .gimmeFive({ gas: 200000, from: accounts[0] }, (err, result) => {
          if (err) console.log(err);
          else console.log(`https://ropsten.etherscan.io/tx/${result}`);
        });
    });
  }
};

export default getRlc;
