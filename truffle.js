var Web3 = require("web3");
var DefaultBuilder = require("truffle-default-builder");

module.exports = {
    build: new DefaultBuilder({
        "index.html": "index.html",
        "app.js": [
            "js/app.js",
            "js/chess.js"
        ],
        "app.css": [
            "css/app.css"
        ]
    }),
      networks: {
        development: {
          host: "localhost",
          port: 8545,
          network_id: "*" // Match any network id
        }
      }
};
