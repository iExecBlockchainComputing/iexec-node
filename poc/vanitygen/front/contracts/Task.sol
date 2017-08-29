pragma solidity ^0.4.8;
import "./Ownable.sol";
contract Task is Ownable{
    function setParam(string, string); // launch process
    function pushResult(address userContract, string res, string url); // the Bridge publish the result
    function getResult() constant returns (string res, string url); // the user get the result
    event Launch(string value, string param, address addr); // special log to launch process
    event Logs(string status, address indexed user); // logs for the front-end or smart contract to react correctly
}
