pragma solidity ^0.4.8;

contract Token {
  function balanceOf(address _owner) constant returns (uint balance);
  function transfer(address _to, uint _value) returns (bool success);
}

contract Faucet{
    Token   public rlc;    // RLC contract reference
    // Constructor of the contract.
    function Faucet(address _token) payable {
        rlc = Token(_token);    // RLC contract address
    }
    
    function gimmeFive() returns (bool success) {
        return rlc.transfer(msg.sender,5000000000);
    }
}