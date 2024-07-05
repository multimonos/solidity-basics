// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

enum Direction {
    North,
    East,
    West,
    South
}

contract EnumType is Test {
    function testEnumEquality() public pure {
        Direction a = Direction.West;

        assertTrue(a == Direction.West);
        assertTrue(uint8(a) == 2);

        assertFalse(a == Direction.East);
    }

    function testEnumValueIsBasedOnAssignmentOrder() public pure {
        // console.logUint(uint8(Direction.North));
        // console.logUint(uint8(Direction.East));
        // console.logUint(uint8(Direction.West));
        // console.logUint(uint8(Direction.South));
        assertEq(uint8(Direction.North), 0);
        assertEq(uint8(Direction.East), 1);
        assertEq(uint8(Direction.West), 2);
        assertEq(uint8(Direction.South), 3);
    }
}
