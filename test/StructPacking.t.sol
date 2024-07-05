// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

contract StructPackingExample {
    struct A {
        string foo;
        uint a;
        uint b;
        uint c;
    }

    struct B {
        string foo;
        uint8 a;
        uint8 b;
        uint32 c;
    }
}

contract TestStructPacking is Test {
    function testA() public pure {
        StructPackingExample.A memory a = StructPackingExample.A(
            "uses gas",
            50,
            60,
            7777777
        );
        assertTrue(a.a == 50);
        assertTrue(a.b == 60);
        assertTrue(a.c == 7777777);
    }

    function testB() public pure {
        StructPackingExample.B memory b = StructPackingExample.B(
            "uses gas",
            50,
            60,
            7777777
        );
        assertTrue(b.a == 50);
        assertTrue(b.b == 60);
        assertTrue(b.c == 7777777);
    }
}
