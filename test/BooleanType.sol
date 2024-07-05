// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

contract BooleanType is Test {

	// boolean
	bool isTrue = true;
	bool isFalse = false;
	bool isDefault;
	bool public hasGetter = true;

	function testBools() public view {
		assertEq(isTrue, true);
		assertEq(isFalse,false);
		assertEq(isDefault,false);
	}

	function testBoolSet() public {
		isDefault = true;
		assertEq(isDefault,true);
	}

	function testBoolGet() public view {
		assertEq(this.hasGetter(), true);
	}
}
