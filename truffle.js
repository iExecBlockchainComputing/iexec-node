var Web3 = require("web3");

module.exports = {
      build: "./node_modules/.bin/webpack",
      networks: {
        development: {
          host: "localhost",
          port: 8545,
          network_id: "*" // Match any network id
        }
      }
};
