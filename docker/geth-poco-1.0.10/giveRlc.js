var erc20;
var rlcDeployer = eth.accounts[0];
var scheduler = eth.accounts[1];
var worker1 = eth.accounts[2];
var worker2 = eth.accounts[3];

function transferRlc(to){
	erc20.transfer(to, 1000, { from: rlcDeployer }, function(err, tx){});
}

function giveRlc(rlcContractAddress){
	var erc20abi = [{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"value","type":"uint256"}],"name":"approve","outputs":[{"name":"ok","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"from","type":"address"},{"name":"to","type":"address"},{"name":"value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"ok","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"who","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"to","type":"address"},{"name":"value","type":"uint256"}],"name":"transfer","outputs":[{"name":"ok","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"owner","type":"address"},{"name":"spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"}];

	erc20 = web3.eth.contract(erc20abi).at(rlcContractAddress);

	console.log("rlc address is "+erc20.address);

	var totalSupply = erc20.totalSupply();
	console.log("totalSupply is " + totalSupply);
	console.log("rlcDeployer balance is " + erc20.balanceOf(rlcDeployer));

	transferRlc(scheduler);
	transferRlc(worker1);
	transferRlc(worker2);

	return "Give Rlc Done";
}
