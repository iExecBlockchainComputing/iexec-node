/* global web3 */

import express from 'express';
import Web3 from 'web3';
import { exec } from 'child_process';
import { accountAddr, vanityContract, contractAddress, task } from './constants';

express();

/**
 * Config Web3
 */
if (typeof web3 !== 'undefined') web3 = new Web3(web3.currentProvider);
else web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

web3.eth.defaultAccount = accountAddr;
console.log(`web3.eth.defaultAccount : ${web3.eth.defaultAccount}`);

/**
 * Config Vanity
 */
const vanitygenContract = web3.eth.contract(vanityContract);
const contractInstance = vanitygenContract.at(contractAddress);

/**
 * Function submitTask
 */
function submitTask(param, address) {
  const newTask = `${task} ${param}`;
  let vanurl = null;
  console.log('submit TASK ', newTask);
  const child = exec(newTask);
  child.stdout.on('data', (data) => {
    console.log(`stdout: ${data}`);
    const running = /RUNNING/i;
    const result = /\n*Address./i;
    const invalid = /Invalid|Download error/i;
    if (data.match(running) && data.match(running)[0]) {
      // console.log("Running ",data);
      contractInstance.broadcast('Running', address, { gas: 200000 }, (error, res) => {
        if (!error) {
          console.log(`res event = ${res}`);
        } else {
          console.log(error);
        }
      });
    }
    if (data.match(invalid) && data.match(invalid)[0]) {
      contractInstance.broadcast('Invalid', address, { gas: 200000 }, (error, r) => {
        if (!error) {
          console.log(`res event = ${r}`);
        } else {
          console.log(error);
        }
      });
      console.log('invalid ', data);
    }
    const url = /UID='([\w\d-]+)'/i;
    if (data.match(url)) {
      vanurl = data.match(url)[1];
      console.log('vanurl', vanurl);

      contractInstance.broadcast(vanurl, address, { gas: 200000 }, (error, res2) => {
        if (!error) {
          console.log(`res event = ${res2}`);
        } else {
          console.log(error);
        }
      });
    }
    if (data.match(result) && data.match(result)[0]) {
      const privKey = /PrivkeyPart: (\w*)/i;
      const addressreg = /Address: \w*/i;
      const vanparam = `${data.match(privKey)[0]} -- ${data.match(addressreg)[0]}`;
      contractInstance.pushResult(address, vanparam, vanurl, { gas: 1000000 }, (error, res3) => {
        if (!error) {
          console.log(`push result ${vanparam} -- ${vanurl}`, 'result', res3);
          child.kill();
        } else {
          console.log(`pushresult err = ${error}`);
        }
      });
      console.log('Running ', data);
    }
  });
  child.stderr.on('data', (data) => {
    console.log(`stderr: ${data}`);
  });
  child.on('close', (code) => {
    console.log(`closing code: ${code}`);
    if (code === '1') {
      contractInstance.broadcast('Invalid', address, { gas: 200000 }, (error, result) => {
        if (!error) {
          console.log(`res event = ${result}`);
        } else {
          console.log(error);
        }
      });
    }
  });
  child.on('error', (code) => {
    console.log(`closing error: ${code}`);
  });
  child.on('exit', (code) => {
    console.log(`closing exit: ${code}`);
  });
  child.on('disconnect', (code) => {
    console.log(`closing exit: ${code}`);
  });
  child.on('message', (code) => {
    console.log(`closing exit: ${code}`);
  });
}
const myEvent = contractInstance.Launch({});
myEvent.watch((err, result) => {
  if (err) {
    console.log('Erreur event ', err);
    return;
  }
  console.log('Event = ', result);
  console.log('Parse ', result.args.param, result.args.addr);
  const params = `-P ${result.args.value} 1${result.args.param}`;
  console.log('params send to submit newTask ', params);

  submitTask(params, result.args.addr);
});
