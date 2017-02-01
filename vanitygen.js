#!/usr/bin/env node
var express = require('express');
var app = express();
var Web3 = require('web3');
const spawn = require('child_process').spawn;
var exec = require('child_process').exec;

//app.get('/', function (req, res) {
//  res.send('Hello World!');
//});

//app.listen(3000, function () {
//  console.log('Example app listening on port 3000!');
//});


if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

web3.eth.defaultAccount=web3.eth.accounts[0];
web3.personal.unlockAccount(web3.eth.defaultAccount, "Iex.ec", "200");


var vanitygenContract = web3.eth.contract([{"constant":false,"inputs":[{"name":"userValue","type":"string"},{"name":"params","type":"string"}],"name":"setParam","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"userAddr","type":"address"},{"name":"keys","type":"string"},{"name":"url","type":"string"}],"name":"pushResult","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"status","type":"string"},{"name":"user","type":"address"}],"name":"broadcast","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getResult","outputs":[{"name":"keyz","type":"string"},{"name":"url","type":"string"}],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"value","type":"string"},{"indexed":false,"name":"param","type":"string"},{"indexed":false,"name":"addr","type":"address"}],"name":"Launch","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"status","type":"string"},{"indexed":true,"name":"user","type":"address"}],"name":"Logs","type":"event"}]);

var contract_adress = "0x4cecd72067a89d4355221ea7a9480c6f643bc53b";
var contractInstance = vanitygenContract.at(contract_adress);
function submitTask( param, address) {
	var task = '/home/ubuntu/run_vanitygen_with_replication.sh "' +  param + '"';
	console.log("submit TASK ", task);
	var child = exec(task);
	child.stdout.on('data', function(data) {
    		console.log('stdout: ' + data);
		var running = /RUNNING/i;
		var result = /\n*Address./i;
		var invalid = /Invalid|Download error/i;
		if (data.match(running) && data.match(running)[0]){
			web3.personal.unlockAccount(web3.eth.defaultAccount, "Iex.ec", "2000");
			
			//console.log("Running ",data);
		contractInstance.broadcast("Running",address,{gas: 200000} ,function(error,result){
        		if (!error){
                		console.log("res event = " +result);
        		} else {
                		console.log(error);
        		}
        	});
		}
		if (data.match(invalid) && data.match(invalid)[0]){
			web3.personal.unlockAccount(web3.eth.defaultAccount, "Iex.ec", "2000");
			
		contractInstance.broadcast("Invalid",address,{gas: 200000} ,function(error,result){
        		if (!error){
                		console.log("res event = " +result);
        		} else {
                		console.log(error);
        		}
        	});
			console.log("invalid ",data);
		}
		var url = /UID='([\w\d-]+)'/i;
		if (data.match(url)) {
			vanurl = data.match(url)[1];
			console.log("vanurl", vanurl);
			web3.personal.unlockAccount(web3.eth.defaultAccount, "Iex.ec", "2000");
				
		contractInstance.broadcast(vanurl,address,{gas: 200000} ,function(error,result){
        		if (!error){
                		console.log("res event = " +result);
        		} else {
                		console.log(error);
        		}
        	});
		}
		if (data.match(result) && data.match(result)[0]){
		var privKey = /PrivkeyPart: (\w*)/i;
		var addressreg = /Address: \w*/i;
		var vanparam = data.match(privKey)[0] + " -- " + data.match(addressreg)[0];
		web3.personal.unlockAccount(web3.eth.defaultAccount, "Iex.ec", "2000");
		contractInstance.pushResult(address,vanparam,vanurl,{gas: 1000000},function(error,result){
	        if (!error){
			console.log("push result "+ vanparam +" -- "+vanurl);
			child.kill();
        	} else {
                	console.log("pushresult err = " +error);
        	}
		});
			console.log("Running ",data);
		}
	});
	child.stderr.on('data', function(data) {
	/*	web3.personal.unlockAccount(web3.eth.defaultAccount, "Iex.ec", "200");
			
		contractInstance.broadcast("Erreur",address,{gas: 200000} ,function(error,result){
        		if (!error){
                		console.log("Logs stderr = " +result);
        		} else {
                		console.log(error);
        		}
        	});*/
    		console.log('stderr: ' + data);
	});
	child.on('close', function(code) {
    		console.log('closing code: ' + code);
		if (code == '1') {
		
			web3.personal.unlockAccount(web3.eth.defaultAccount, "Iex.ec", "2000");
			
		contractInstance.broadcast("Invalid",address,{gas: 200000} ,function(error,result){
        		if (!error){
                		console.log("res event = " +result);
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
myEvent.watch(function(err, result){
	if (err) {
		console.log("Erreur event ", err);
		return;
	}
	console.log("Event = ", result);
	console.log("Parse ",result.args.param,result.args.addr);
	var params = "-P " + result.args.param + " 1" + result.args.value;
	console.log("params send to submit task ", params);

	//console.log("Event = ", JSON.parse(result.args.value));
	submitTask(params, result.args.addr);
});


