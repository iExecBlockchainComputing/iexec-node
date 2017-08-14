#!/usr/bin/env node

var express = require('express');
var app = express();
var Web3 = require('web3');
const spawn = require('child_process').spawn;
var exec = require('child_process').exec;
var fs = require('fs');

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}


web3.eth.defaultAccount = web3.eth.accounts[0];

var stockfishContract = web3.eth.contract([{
    "constant": false,
    "inputs": [{
        "name": "userMove",
        "type": "string"
    }],
    "name": "setParam",
    "outputs": [],
    "payable": false,
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "kill",
    "outputs": [],
    "payable": false,
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "flushGame",
    "outputs": [],
    "payable": false,
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "owner",
    "outputs": [{
        "name": "",
        "type": "address"
    }],
    "payable": false,
    "type": "function"
}, {
    "constant": false,
    "inputs": [{
        "name": "status",
        "type": "string"
    }, {
        "name": "user",
        "type": "address"
    }],
    "name": "broadcast",
    "outputs": [],
    "payable": false,
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "undoMove",
    "outputs": [],
    "payable": false,
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getResult",
    "outputs": [{
        "name": "game",
        "type": "string"
    }],
    "payable": false,
    "type": "function"
}, {
    "constant": false,
    "inputs": [{
        "name": "userAddr",
        "type": "address"
    }, {
        "name": "newAIMove",
        "type": "string"
    }],
    "name": "pushResult",
    "outputs": [],
    "payable": false,
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "reDo",
    "outputs": [],
    "payable": false,
    "type": "function"
}, {
    "constant": true,
    "inputs": [{
        "name": "userMove",
        "type": "string"
    }],
    "name": "checkValidity",
    "outputs": [{
        "name": "validity",
        "type": "bool"
    }],
    "payable": false,
    "type": "function"
}, {
    "anonymous": false,
    "inputs": [{
        "indexed": false,
        "name": "value",
        "type": "string"
    }, {
        "indexed": false,
        "name": "addr",
        "type": "address"
    }],
    "name": "Launch",
    "type": "event"
}, {
    "anonymous": false,
    "inputs": [{
        "indexed": false,
        "name": "status",
        "type": "string"
    }, {
        "indexed": true,
        "name": "user",
        "type": "address"
    }],
    "name": "Logs",
    "type": "event"
}]);

var contract_address ="0x77ce934092f9a669e6dd9b547814dc4ebcb0d782";
var contractInstance = stockfishContract.at(contract_address);

function submitTask(address) {
    var task = '/home/vagrant/iexecdev/bridge_stockfish/stockfishback/run_stockfish_with_replication.sh /dev/shm/' + address;
    console.log("submit TASK ", task);
    var child = exec(task);
    child.stdout.on('data', function(data) {
        console.log('stdout: ' + data);
        var running = /RUNNING/i;
        var result = /bestmove.[(]?(\w+)[)]?/i;
        var invalid = /Invalid|Download error/i;
        if (data.match(invalid) && data.match(invalid)[0]) {

            console.log("Case Invalid : ", data);

            contractInstance.broadcast("Invalid", address, {
                gas: 200000
            }, function(error, result) {
                if (!error) {
                    console.log("res event = " + result);
                } else {
                    console.log(error);
                }
            });
        } else if (data.match(running) && data.match(running)[0]) {

            console.log("Case Running : ", data);

            contractInstance.broadcast("Running", address, {
                gas: 200000
            }, function(error, result) {
                if (!error) {
                    console.log("res event = " + result);
                } else {
                    console.log(error);
                }
            });
        } else if (data.match(result) && data.match(result)[1]) {

            console.log("Case Completed : ", data);
            console.log("push result " + data.match(result)[0]);
            console.log("push result " + data.match(result)[1]);
            

            contractInstance.pushResult(address, data.match(result)[1], {
                gas: 1000000
            }, function(error, result) {
                if (!error) {
                    child.kill();
		    console.log("transactionHash : " + result);
                } else {
                    console.log("pushresult err = " + error);
                }
            });
            if (fs.existsSync("/dev/shm/" + address)) {
                fs.unlinkSync("/dev/shm/" + address);
                console.log("Successfully deleted " + address);
            }
        }
    });
    child.stderr.on('data', function(data) {
        console.log('stderr: ' + data);
    });
    child.on('close', function(code) {
        console.log('closing code: ' + code);
        if (code == '1') {

            contractInstance.broadcast("Invalid", address, {
                gas: 200000
            }, function(error, result) {
                if (!error) {
                    console.log("res event = " + result);
                } else {
                    console.log(error);
                }
            });

        }
    });
    child.on('error', function(code) {
        console.log('closing error: ' + code);
    });
    child.on('exit', function(code) {
        console.log('closing exit: ' + code);
    });
    child.on('disconnect', function(code) {
        console.log('closing exit: ' + code);
    });
    child.on('message', function(code) {
        console.log('closing exit: ' + code);
    });

}

var myEvent = contractInstance.Launch({});
myEvent.watch(function(err, result) {
    if (err) {
        console.log("Erreur event ", err);
        return;
    }
    console.log("Event = ", result);
    var moves = result.args.value.split(" ").reverse().join(" ");
    fs.writeFileSync("/dev/shm/" + result.args.addr, "position startpos moves " + moves + "\ngo depth 20\n");
    console.log("Successfully created " + result.args.addr);

    submitTask(result.args.addr);
});
