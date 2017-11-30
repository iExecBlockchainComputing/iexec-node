var keythereum = require("keythereum");
var fs = require('fs');
const password = "whatever";
const wallet = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const key = keythereum.recover("whatever", wallet);
console.log(wallet.address+"_"+key.toString('hex'));


