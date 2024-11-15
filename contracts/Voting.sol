pragma solidity ^0.4.11;

 // SPDX-License-Identifier: MIT
contract Ballot {
    struct ballotVoter {
        uint delegateWeight; 
        bool voteSpent;  
        address delegateTo; 
        uint voteIndex;   
    }

    struct Proposal {
        bytes32 proposalName;   
        uint voteCount; 
    }

    address public chairman;

    mapping(address => ballotVoter) public ballotVoters;

    Proposal[] public proposalsOption;

    function Ballot(bytes32[] proposalNames) {
        chairman = msg.sender;
        ballotVoters[chairman].delegateWeight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
           
            proposalsOption.push(Proposal({
                proposalName: proposalNames[i] ,
                voteCount: 0
            }));
        }
    }

    function giveVotingRights(address ballotVoter) {
       
        require((msg.sender == chairman) && !ballotVoters[ballotvoter].voteSpent && (ballotVoters[ballotvoter].delegateWeight == 0));
        ballotVoters[ballotvoter].delegateWeight = 1;
    }

    function delegateTo(address to) {
        ballotVoter storage sender = ballotVoters[msg.sender];
        require(!sender.voteSpent);

        require(to != msg.sender);

       
        while (ballotVoters[to].delegateTo != address(0)) {
            to = ballotVoters[to].delegateTo;

            require(to != msg.sender);
        }

        sender.voteSpent = true;
        sender.delegateTo = to;
        ballotVoter storage delegateTo = ballotVoters[to];
        if (delegateTo.voteSpent) {
            proposalsOption[delegateTo.voteIndex].voteCount += sender.delegateWeight;
        } else {
            
            delegateTo.delegateWeight += sender.delegateWeight;
        }
    }

    function voteIndex(uint proposal) {
        ballotVoter storage sender = ballotVoters[msg.sender];
        require(!sender.voteSpent);
        sender.voteSpent = true;
        sender.voteIndex = proposal;

        
        proposalsOption[proposal].voteCount += sender.delegateWeight;
    }

    function winnerProposal() constant
            returns (uint winnerProposal)
    {
        uint winnerVoteCount = 0;
        for (uint p = 0; p < proposalsOption.length; p++) {
            if (proposalsOption[p].voteCount > winnerVoteCount) {
                winnerVoteCount = proposalsOption[p].voteCount;
                winnerProposal = p;
            }
        }
    }

   
    function winner() constant
            returns (bytes32 winner)
    {
        winner = proposalsOption[winnerProposal()].proposalName;
    }
}