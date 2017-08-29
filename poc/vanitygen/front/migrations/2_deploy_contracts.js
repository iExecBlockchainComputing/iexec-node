/* global artifacts */
  // eslint-disable-next-line
var RLC = artifacts.require("./RLC.sol");
  // eslint-disable-next-line
var Faucet = artifacts.require("./Faucet.sol");
  // eslint-disable-next-line
var VanityGen = artifacts.require("./VanityGen.sol");
  // eslint-disable-next-line
var faucet;
  // eslint-disable-next-line
var rlc;
  // eslint-disable-next-line
module.exports = function(deployer) {  // eslint-disable-next-line
  deployer.deploy(RLC).then(function() {  // eslint-disable-next-line
    return deployer.deploy(Faucet,RLC.address).then(function(){  // eslint-disable-next-line
      return Faucet.deployed();  // eslint-disable-next-line
    }).then(function(instance){  // eslint-disable-next-line
      faucet = instance;
      return RLC.deployed();  // eslint-disable-next-line
    }).then(function(instance){
      rlc = instance;
      return rlc.transfer(faucet.address, 100000000000000);  // eslint-disable-next-line
    }).then(function(){  // eslint-disable-next-line
      return deployer.deploy(VanityGen, rlc.address)  // eslint-disable-next-line
    })  // eslint-disable-next-line
  });  // eslint-disable-next-line
};
