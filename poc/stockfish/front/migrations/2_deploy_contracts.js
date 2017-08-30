var stockfish = artifacts.require("./stockfish.sol");

module.exports = function(deployer) {
  deployer.deploy(stockfish);
};
