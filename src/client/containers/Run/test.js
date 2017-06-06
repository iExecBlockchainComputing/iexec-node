/* global  web3 */
import Vanity from '../../../build/contracts/VanityGen.json';

const vanityContract = web3.eth.contract(Vanity.abi);
const VanityInstance = vanityContract.at('0x902ed0d4b16871ec159dd4fb58b40c9cd0456ee9');
// VanityGen.deployed().then((instance) => {
const myEvent = VanityInstance.Logs({ user: web3.eth.accounts[0] });
myEvent.watch((err, result) => {
  if (err) {
    console.log('Erreur event ', err);
    return;
  } else if (result.args.status === 'Task finish!') {
    this.vanityWallet();
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
  console.log(JSON.parse(result.args.value));
});
// });
