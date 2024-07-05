// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";

contract Contract {
	enum Relationship {
		Coworker,
		Friend,
		Family
	}

	mapping ( address=>
		mapping(address => Relationship)
	) public connections;

	function connectWith(address x, Relationship relation) external {
		connections[msg.sender][x] = relation;
	}
}