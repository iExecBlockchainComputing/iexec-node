/* global RLC VanityGen web3 */
window.onload = () => {
  VanityGen.deployed().then((instance) => {
    const vanity = instance;
    console.log(`https://ropsten.etherscan.io/address/${vanity.address}`);
  });

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
};
