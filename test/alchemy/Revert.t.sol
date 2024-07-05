// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

contract LearnRevert {

    error RevertWasForced();

    function attemptRevert(bool forceRevert) public pure returns(bool) {
        if (forceRevert) {
			revert RevertWasForced();
		}
        return true;
    }
}

contract TestRevert is Test {

	LearnRevert public a;

	function setUp() public {
        a = new LearnRevert();
	}

    function testWasReverted() public {
        vm.expectRevert();
        a.attemptRevert(true);
    }

	function testNotReverted() public view {
		bool ok = a.attemptRevert(false);
		assert(ok);
	}
}
