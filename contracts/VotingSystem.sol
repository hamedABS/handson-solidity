// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VotingSystem {

    address public owner; 

    struct Poll{
        string question;
        string[] options;
        mapping(address=> bool) voted;
        mapping(address=> string) userVotes;
        mapping(uint=> uint) voteCounts;
        bool isOpen;
        uint deadline;
    }

    constructor(){
        owner = msg.sender;
    }

    Poll[] public polls;

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this.");
        _;
    }

    function createPoll(string memory _question, string[] memory _options, uint _deadline)  external onlyOwner {
        require(_options.length>=2,"At least 2 options required");
        require(_deadline > 0,"Duration must be >0");

        Poll storage newPoll = polls.push();
        newPoll.question = _question;
        newPoll.options = _options;
        newPoll.isOpen= true;
        newPoll.deadline = block.timestamp + _deadline;
    }

    function vote(uint _indexOfPoll, uint _indexOfQuestion) external {
        require(polls.length > _indexOfPoll,"poll index out of bound exception");
        Poll storage poll = polls[_indexOfPoll];

        require(poll.options.length>_indexOfQuestion, "options out of bound exception");
        require(poll.isOpen,"Poll has closed.");
        require(!poll.voted[msg.sender],"You voted before");
        require(block.timestamp <= poll.deadline, "Voting period has ended");


        poll.voteCounts[_indexOfQuestion]++;
        poll.voted[msg.sender]= true;
    }
    function closePoll(uint pollIndex) external onlyOwner {
        require(pollIndex < polls.length, "Invalid poll index");
        Poll storage poll = polls[pollIndex];
        require(poll.isOpen, "Poll is already closed");
        poll.isOpen = false;
    }

    function getWinner(uint _pollIndex) external view onlyOwner returns (string[] memory){
        require(polls.length> _pollIndex,"polls index out of bound exeption");

        uint winnerCount=0;
        uint maxVote=0;
        Poll storage poll = polls[_pollIndex];
        uint[] memory tmpWinners = new uint[](poll.options.length);
        

        for (uint i= 0; i < polls[_pollIndex].options.length; i++){
            if (poll.voteCounts[i] > maxVote){
                maxVote = poll.voteCounts[i];
                winnerCount = 1;
                tmpWinners[0] = i;
            } else if (poll.voteCounts[i] == maxVote){
                tmpWinners[winnerCount++]=i;
            }
        }

        string[] memory winners = new string[](winnerCount); 
        for (uint i = 0; i<tmpWinners.length; i++){
            winners[i]= poll.options[i];
        }

        return winners;
    }

    // function getVotes(string memory _pollIndex) external view onlyOwner returns(string[] memory, bool[] memory){
    //     //require(polls.length > _indexOfPoll,"poll index out of bound exception");
    //      Poll storage poll = polls[_indexOfPoll];


    //     return mapping() 
    // }
}