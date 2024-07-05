// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

contract Club {
    address[] members;

    function addMember(address member) external returns (bool) {
        if (isMember(member)) {
            return false;
        }

        members.push(member);
        return true;
    }

    function isMember(address member) public view returns (bool) {
        uint i = 0;

        while (i < members.length) {
            if (member == members[i]) {
                return true;
            }
            i++;
        }
        return false;
    }

	function size() external view returns (uint) {
		return members.length;
	}
}

contract TestClub is Test {
    Club club;

    function setUp() public {
        club = new Club();
    }

    function testIsMember() public view {
        address a = address(2);
        assertFalse(club.isMember(a));
    }
    function testCanAddMember() public {
        address a = address(1);
        club.addMember(a);
        assertTrue(club.isMember(a));
		assertEq(club.size(),1);
    }
	function testCanOnlyAddMemberOnce() public  {
        address a = address(1);
        club.addMember(a);
        club.addMember(a);
		assertEq(club.size(),1);
	}


}
