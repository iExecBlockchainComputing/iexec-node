/* global artifacts */
const RLC = artifacts.require('./RLC.sol');
const Faucet = artifacts.require('./Faucet.sol');
const VanityGen = artifacts.require('./VanityGen.sol');
let faucet;
let rlc;

module.exports = (deployer) => {
  deployer.deploy(RLC).then(() =>
    deployer
      .deploy(Faucet, RLC.address)
      .then(() => Faucet.deployed())
      .then((instance) => {
        faucet = instance;
        return RLC.deployed();
      })
      .then((instance) => {
        rlc = instance;
        return rlc.transfer(faucet.address, 100000000000000);
      })
      .then(() => deployer.deploy(VanityGen, rlc.address)),
  );
};
