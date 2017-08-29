/* global web3 */
import Vanity from '../../build/contracts/VanityGen.json';
import rlc from '../../build/contracts/RLC.json';
import { getSmartContractAddressByJsonNetworks } from '../vanity/utils';

const generateVanity = (letter, pubkey) => {
  if (window.web3.eth.accounts[0]) {
    let value = letter;

    value = value.replace(/l/g, '1');
    value = value.replace(/I/g, '1');
    value = value.replace(/O/g, '1');
    value = value.replace(/0/g, '1');
    value = value.replace(/\W/g, '1');

    const vanityContract = web3.eth.contract(Vanity.abi);
    //  const VanityInstance = vanityContract.at('0x8099be7909174ed81980e21bedded95c2f987c0f');
    const VanityInstance = vanityContract.at(
      getSmartContractAddressByJsonNetworks(Vanity.networks));

    const rlcContract = web3.eth.contract(rlc.abi);
    //  const rlcInstance = rlcContract.at('0x9978b9a251e2f1b306dde81830c7bc97c5e6e149');
    const rlcInstance = rlcContract.at(getSmartContractAddressByJsonNetworks(rlc.networks));
    rlcInstance
      .approveAndCall(VanityInstance.address, 1000000000, pubkey,
      value, { gas: 100000 }, (err, result) => {
        if (err) console.log(err);
        else console.log(`https://ropsten.etherscan.io/tx/${result}`);
      });
  }
};

export default generateVanity;
