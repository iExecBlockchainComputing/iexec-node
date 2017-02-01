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
    function setParam(string, string); // launch process
    function pushResult(address userContract, string res, string url); // the Bridge publish the result
    function getResult() constant returns (string res, string url); // the user get the result
    event Launch(string value, string param, address addr); // special log to launch process
    event Logs(string status, address indexed user); // logs for the front-end or smart contract to react correctly
}

contract VanityGen is Task {
    struct Vanity {
        string myKeys;
        string url;
    }
    mapping (address => Vanity ) vanityRegister;
    function setParam(string userValue, string params) public {
        if (bytes(userValue).length == 0) throw;
        if (bytes(userValue).length > 5) throw;  // max vanity lenght
        Launch(userValue, params, msg.sender);
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
    function broadcast(string status, address user) onlyowner // for the front-end or smart contract watcher to know the step of the task
    {
        Logs(status, user);
    }
    function kill() onlyowner {
        selfdestruct(owner);
    }
}

