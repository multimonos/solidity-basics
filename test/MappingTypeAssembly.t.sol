// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

contract Contract {
    // storage only
    mapping(address => bool) members;

    function addMember() external {
        members[msg.sender] = true;
    }

    function isMember() external view returns (bool) {
        return members[msg.sender];
    }

    function addMemberAssembly() external {
        bytes32 slot = keccak256(abi.encode(msg.sender, 0));
        assembly {
            sstore(slot, true)
        }
    }

    function isMemberAssembly() external view returns (bool) {
        bool rs;

        bytes32 slot = keccak256(abi.encode(msg.sender, 0));

        assembly {
            rs := sload(slot)
        }

        return rs;
    }
}

contract TestContract is Test {
    function testAddMember() public {
        Contract a = new Contract();
        vm.prank(address(1));
        a.addMember();

        vm.prank(address(1));
        bool isMember = a.isMember();

        assertTrue(isMember);
    }

    function testNotMember() public {
        Contract a = new Contract();
        vm.prank(address(1));
        bool isMember = a.isMember();
        assertFalse(isMember);
    }

    function testAddMemberAssembly() public {
        Contract a = new Contract();
        vm.prank(address(1));
        a.addMemberAssembly();

        vm.prank(address(1));
        bool isMember = a.isMember();

        assertTrue(isMember);
    }

    function testIsMemberAssembly() public {
        Contract a = new Contract();
        vm.prank(address(1));
        a.addMember();

        vm.prank(address(1));
        bool isMember = a.isMemberAssembly();

        assertTrue(isMember);
    }

    function testNotMemberAssembly() public {
        Contract a = new Contract();
        vm.prank(address(1));
        bool isMember = a.isMemberAssembly();
        assertFalse(isMember);
    }
}
