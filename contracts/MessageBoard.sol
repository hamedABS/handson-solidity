// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;  // Use Solidity 0.8.)

contract MessageBoard{
    string public message; 
    address public owner;

    event  MessageChanged(address indexed changer, string oldMessage, string newMessage);

    constructor(string memory _message) {
        message = _message;
        owner = msg.sender;
    }
    
    modifier onlyOwner{
        require(msg.sender == owner, "Only Owner can call this function."); 
        _;
    }

    function setMessage(string memory newMessage) public onlyOwner {
        require(
        keccak256(bytes(newMessage)) != keccak256(bytes(message)),
        "New message must be different from current one.");

        string memory oldMessage = message;
        message = newMessage;

        emit MessageChanged(owner, oldMessage,newMessage);
    }

    function repeatMessage(string memory _message) public pure returns(string memory){
        return string( abi.encodePacked( "Bashee ", _message, " BABA"));
    }
    
    function repeatMessageExternal(string calldata _message) public pure returns(string memory) {
        return  string( abi.encodePacked(repeatMessage(_message), "  Hajiii ...."));
    }
}