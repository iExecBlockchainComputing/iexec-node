/* global web3 */

import express from 'express';
import http from 'http';
import Web3 from 'web3';
import { accountAddr, vanityContract, contractAddress } from './constants';

const app = express();
const server = http.createServer(app);

/**
 * Config Web3
 */
if (typeof web3 !== 'undefined') web3 = new Web3(web3.currentProvider);
else  web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

web3.eth.defaultAccount = accountAddr;
console.log(`web3.eth.defaultAccount : ${web3.eth.defaultAccount}`);

/**
 * Config Vanity
 */
const vanitygenContract = web3.eth.contract(vanityContract);
const contractInstance = vanitygenContract.at(contractAddress);













server.listen(8080, () => console.log('server started on port 8080'));
