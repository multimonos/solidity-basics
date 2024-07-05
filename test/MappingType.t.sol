// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";

// mappings
//
// - storage only
// - key can be any basic type
// - value can be any type

contract Contract {
    struct User {
        uint balance;
        bool isActive;
    }

    mapping(address => bool) members; // constant time lookup
    mapping(address => User) users;

    function addMember(address x) external {
        members[x] = true;
    }

    function isMember(address x) external view returns (bool) {
        return members[x] == true;
    }

    function removeMember(address x) external {
        members[x] = false; // weird, exercise language is odd.
    }

	function createUser() external {
		users[msg.sender] = User({balance:100, isActive:true});
	}

}

contract TestContract is Test {
	
	mapping(address => Contract.User) users;

	function testUserExistence() public view {
		Contract.User memory user = users[address(3)];
		assertFalse(user.isActive);
		assertEq(user.balance,0);
	}
}
