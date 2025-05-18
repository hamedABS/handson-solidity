// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    struct Candidate {
        string name;
        uint voteCount;
    }

    address public owner;
    mapping(address => bool) public hasVoted;
    Candidate[] private candidates;

    constructor(string[] memory candidateNames) {
        owner = msg.sender;
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate(candidateNames[i], 0));
        }
    }

    function vote(uint candidateIndex) public {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(candidateIndex < candidates.length, "Invalid candidate.");

        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount++;
    }

    function getCandidates() public view returns (Candidate[] memory) {
        require(msg.sender == owner,"You are not the owner.");
        return candidates;
    }
}
