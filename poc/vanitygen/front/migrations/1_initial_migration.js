/* global artifacts */
  // eslint-disable-next-line
var Migrations = artifacts.require("./Migrations.sol");
  // eslint-disable-next-line
module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
