pragma solidity ^0.4.8;

import "./RLC.sol";
import "./Task.sol";


contract VanityGen is Task{
    RLC iextoken;
    address _iextokenAddr;
    bool public launched;
    struct Vanity {
        string myKeys;
        string url;
    }
    mapping (address => Vanity ) vanityRegister;
    function VanityGen(address _iextoken){
        _iextokenAddr = _iextoken;
        iextoken = RLC(_iextoken);
        launched = false;
    }
    function setParam(string userValue, string params) public {
        if (bytes(userValue).length == 0) throw;
        if (bytes(userValue).length > 5) throw;  // max vanity lenght
        // approve
        //iextoken.approve(this, 1000000000);
        if (!iextoken.transferFrom(msg.sender, owner, 1000000000)) throw ;
        Launch(userValue, params, msg.sender);
        launched = true;
    }
    function receiveApproval(address _from, uint256 _value, address _token, string _extraData, string _extraData2) {
        if (msg.sender != _iextokenAddr) throw;
        if (bytes(_extraData).length == 0) throw;
        if (bytes(_extraData2).length > 5) throw;  // max vanity lenght
        if (_value != 1000000000) throw; // vanity cost
        if (!iextoken.transferFrom(_from, owner, _value)) throw ;
        Launch(_extraData, _extraData2, _from);
        launched = true;
    }
    function pushResult(address userAddr, string keys, string url) onlyOwner {
        vanityRegister[userAddr].myKeys = keys;
        vanityRegister[userAddr].url = url;
        Logs("Task finish!",userAddr);
    }
    function getResult () constant returns (string keyz, string url) {
        if (bytes(vanityRegister[msg.sender].myKeys).length == 0) throw;
        return (vanityRegister[msg.sender].myKeys , vanityRegister[msg.sender].url);
    }
    function broadcast(string status, address user) onlyOwner // for the front-end or smart contract watcher to know the step of the task
    {
        Logs(status, user);
    }
    function kill() onlyOwner {
        selfdestruct(owner);
    }
}
