/* global web3 */
import Vanity from '../../build/contracts/VanityGen.json';
import rlc from '../../build/contracts/RLC.json';

const generateVanity = (letter, pubkey) => {
  let value = letter;

  value = value.replace(/l/g, '1');
  value = value.replace(/I/g, '1');
  value = value.replace(/O/g, '1');
  value = value.replace(/0/g, '1');
  value = value.replace(/\W/g, '1');

  const vanityContract = web3.eth.contract(Vanity.abi);
  const VanityInstance = vanityContract.at('0x902ed0d4b16871ec159dd4fb58b40c9cd0456ee9');

  const rlcContract = web3.eth.contract(rlc.abi);
  const rlcInstance = rlcContract.at('0x93e2163fd20d27285d09e230d3a214e1d0e9f863');
  rlcInstance
    .approveAndCall(VanityInstance.address, 1000000000, pubkey,
    value, { gas: 100000 }, (err, result) => {
      if (err) console.log(err);
      else console.log(`https://ropsten.etherscan.io/tx/${result}`);
    });
};

export default generateVanity;
