pragma solidity ^0.4.6;

contract owned{
  function owned() {
    owner = msg.sender;
  }

  modifier onlyowner() {
    if(msg.sender==owner) _;
  }

  address public owner;
}

contract Task is owned{
    function setParam(string);
    function pushResult(address userContract, string res, string url);
    function getResult() constant returns (string res, string url);
    event Launch(string param, address addr);
    event Logs(string status, address user);
}

contract VanityGen is Task {
    struct Vanity {
        string myKeys;
        string url;
    }
    mapping (address => Vanity ) vanityRegister;
    function setParam(string userParam) public {
        if (bytes(userParam).length == 0) throw;
        if (bytes(userParam).length > 5) throw;  // max vanity lenght
        Launch(userParam, msg.sender);
    }
    function pushResult(address userAddr, string keys, string url) onlyowner {
        vanityRegister[userAddr].myKeys = keys;
        vanityRegister[userAddr].url = url;
        Logs("Task finish!",userAddr);
    }
    function getResult () constant returns (string keyz, string url) {
        if (bytes(vanityRegister[msg.sender].myKeys).length == 0) throw;
        return (vanityRegister[msg.sender].myKeys , vanityRegister[msg.sender].url);
    }
    function broadcast(string status, address user) onlyowner
    {
        Logs(status, user);
    }
    function kill() onlyowner {
        selfdestruct(owner);
    }
}

