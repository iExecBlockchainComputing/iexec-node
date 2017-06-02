/* global VanityGen RLC Faucet */

export const generateVanity = (letter, pubkey) => {
  let value = letter;
  let vanitygen;

  value = value.replace(/l/g, '1');
  value = value.replace(/I/g, '1');
  value = value.replace(/O/g, '1');
  value = value.replace(/0/g, '1');
  value = value.replace(/\W/g, '1');

  VanityGen.deployed()
    .then((instance) => {
      vanitygen = instance;
      console.log('vanity ', instance);
      return RLC.deployed();
    })
    .then((instance) => {
      console.log('rlc', instance);
      console.log('vanityGen ', vanitygen.address, ' pubkey ', pubkey, ' value ', value);
      return instance.approveAndCall(vanitygen.address, 1000000000, pubkey, value, { gas: 100000 });
    })
    .then((result) => {
      console.log(`res = ${result.tx}`);
      console.log(`https://ropsten.etherscan.io/tx/${result.tx}`);
    })
    .catch((e) => {
      console.log('error ', e);
    });
};

export const faucet = () => {
  Faucet.deployed().then((instance) => {
    instance
      .gimmeFive({ gas: 200000 })
      .then((result) => {
        console.log(`result faucet = ${result}`);
      })
      .catch((e) => {
        console.log(`e ${e}`);
      });
  });
};
