// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

contract Contract {
    address owner;
    error IsNotOwner();

    modifier onlyOwner() {
        if (owner != msg.sender) revert IsNotOwner();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function log() external view onlyOwner {
        console.log(owner);
    }

    // Modifier with args.
    address[] public drivers;

    modifier atLeast(uint _min, uint _age) {
        require(_age >= _min);
        _;
    }

    function createDriver(
        address _address,
        uint _age
    ) external atLeast(16, _age) {
        drivers.push(_address);
    }

    function driverCount() external view returns(uint){
        return drivers.length;
    }
}

contract TestContract is Test {
    Contract a;
    address owner = address(2);
    address pirate = address(3);

    function setUp() public {
        vm.prank(owner);
        a = new Contract();
    }

    function testRevert() public {
        vm.expectRevert();
        vm.prank(pirate);
        a.log();
        assertTrue(true, "revert success");
    }

    function testNoRevert() public {
        vm.prank(owner);
        a.log();
        assertTrue(true, "no revert occurred");
    }

    function testCreateDriverFailed() public {
        vm.expectRevert();
        a.createDriver(address(0), 15);
        assertTrue(a.driverCount()==0);
    }
    function testCreateDriverSuccess() public {
        a.createDriver(address(0), 17);
        assertTrue(a.driverCount()==1);
    }

}
