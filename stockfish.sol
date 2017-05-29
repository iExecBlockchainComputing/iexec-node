pragma solidity ^0.4.6;

import "github.com/Arachnid/solidity-stringutils/strings.sol";

contract owned{
  function owned() {
    owner = msg.sender;
  }

  modifier onlyowner() {
    if(msg.sender==owner) _;
  }

  address public owner;
}

contract task is owned{
    function setParam(string userMove); // launch process
    function pushResult(address userAddr, string newAIMove); // the Bridge publish the result
    function getResult () constant returns (string game); // the user get the result
    event Launch(string value, address addr); // special log to launch process
    event Logs(string status, address indexed user); // logs for the front-end or smart contract to react correctly

    function broadcast(string status, address user) onlyowner {
        Logs(status, user);
    }

    function kill() onlyowner {
        selfdestruct(owner);
    }
}

contract stockfish is task {

    using strings for *;

    struct Chess {
        string game;
    }

    mapping (address => Chess) chessRegister;

    function checkValidity(string userMove) constant returns (bool validity) {
        if (userMove.toSlice().len() != 4) return false;
        else if (bytes(userMove)[0] < "a" || bytes(userMove)[0] > "h") return false;
        else if (bytes(userMove)[1] < "1" || bytes(userMove)[1] > "8") return false;
        else if (bytes(userMove)[2] < "a" || bytes(userMove)[2] > "h") return false;
        else if (bytes(userMove)[3] < "1" || bytes(userMove)[3] > "8") return false;
        else return true;
    }

    function setParam(string userMove)  {
        bool validity = checkValidity(userMove);
        if (!validity) {
            Launch("ERROR", msg.sender);
            throw;
        }
        if (chessRegister[msg.sender].game.toSlice().len() != 0)
          chessRegister[msg.sender].game = " ".toSlice().concat(chessRegister[msg.sender].game.toSlice()); // separate moves
        chessRegister[msg.sender].game = userMove.toSlice().concat(chessRegister[msg.sender].game.toSlice());
        Launch(chessRegister[msg.sender].game, msg.sender);
    }

    function undoMove() {
        var game = chessRegister[msg.sender].game.toSlice();
        for(var nbmoves=0; nbmoves<2; nbmoves++) { // delete the player move and the IA move
            game.split(" ".toSlice());
        }
        chessRegister[msg.sender].game = game.toString();
        Logs("Task finished !", msg.sender);
    }

    function flushGame() {
        chessRegister[msg.sender].game = "";
        Logs("Task finished !", msg.sender);
    }

    function pushResult(address userAddr, string newAIMove) onlyowner {
        if (chessRegister[userAddr].game.toSlice().len() != 0)
          chessRegister[userAddr].game = " ".toSlice().concat(chessRegister[userAddr].game.toSlice());
        chessRegister[userAddr].game = newAIMove.toSlice().concat(chessRegister[userAddr].game.toSlice());
        Logs("Task finished !",userAddr);
    }

    function getResult() constant returns (string game) {
        return (chessRegister[msg.sender].game);
    }
}
