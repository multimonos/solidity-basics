// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";

/**
Requirements.
- any member can create a proposal
- only members can vote on proposal
- all members can vote 
- proposal execute iff "yes threshold is reached"
- proposal execution means that calldata is sent to a contract

Sample data,
ProposalID	Calldata 	TargetContract YesCount NoCount
0			0x123		0x123			100		20
1			0xasdf3		0x234			56		10		
2			0x4di		0x345			75		5
...

Contract becomes like an EOA that requires voter approval for each of it's actions.
 */

contract Registry {

    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
    }

    Proposal[] public proposals;

	function createProposal(address target, bytes memory data) external {
		Proposal memory p = Proposal({
			target: target,
			data: data,
			yesCount :0,
			noCount:0
		});
		proposals.push(p);
	}

	function vote(uint proposalId, bool inFavour) external {
		if(inFavour)  proposals[proposalId].yesCount++;
		if(!inFavour) proposals[proposalId].noCount++;
	}
}

contract VotingTest is Test {
    Registry r;

    function setUp() public {
        r = new Registry();
    }
    function testCreateProposal() public {
		r.createProposal(address(1),"foobar");
		(address target, bytes memory data,,) = r.proposals(0);
		assertEq(target,address(1));
		assertEq(data,"foobar");
	}
}
