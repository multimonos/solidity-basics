// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

contract IntegerType is Test {
    // unsigned
    uint a = 42;
    uint public b = 666;
    uint c;
    uint16 d = type(uint16).min;

    // signed
    int e = -57;

    function testIsAlias() public pure {
        uint aMax = type(uint256).max;
        uint256 bMax = type(uint256).max;
        assertEq(aMax, bMax);
    }

    function testIsDefaultZero() public view {
        assertEq(c, 0);
    }

    function testSet() public {
        c = 5;
        assertEq(c, 5);
    }

    function testGet() public view {
        assertEq(this.b(), 666);
    }

    function testInitWithTypeMin() public view {
        assertEq(d, type(uint16).min);
    }

    function testIsNegative() public view {
        assert(e < 0);
    }

    function testShouldAccountForSize() public pure {
        int8 f = type(int8).min;
        int8 g = 20;
        int16 h = -128 - 20; // ok
        // int16 id = f - g; // ERR fails with underflow err
        // int16 ig = int16(f - g); // ERR also fails, same stmt as previous.
        int16 i = int16(f) - int16(g); // correct

		assertEq(h, -148);
		assertEq(i, -148);
        // op = has precedence 14
        // op + has precedence 5
        // so, the underflow is occurring on the right side of =
        // and not during assignment.
    }
}
