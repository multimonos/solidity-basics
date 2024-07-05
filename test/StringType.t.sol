// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

contract StringType is Test {

    function testDoubleQuotesOk() public pure {
        bytes32 a = "foo";
        assertEq("foo", a);
    }

    function testSingleQuotesOk() public pure {
        bytes32 a = 'foo';
        assertEq('foo', a);
    }

	function testEquality() public pure {
		bytes32 a = "foo";
		string memory b = "foo";
		// assertEq(a, bytes32(b)); // not allowed
		assertEq("foo" , a);
		assertEq("foo" , b);
	}

}
