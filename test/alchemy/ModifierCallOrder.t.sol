// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

contract Contract {

    modifier beforeware() {
        _;
        console.log("after");
    }

    modifier middleware() {
        console.log("before");
        _;
        console.log("after");
    }

    modifier afterware() {
        console.log("before");
        _;
    }

    function runBefore() public view beforeware{
        console.log("self");
    }

    function runMiddle() public view middleware {
        console.log("self");
    }

    function runAfter() public view afterware {
        console.log("self");
    }

}

contract TestModifiers is Test {
    Contract a;

    function setUp() public {
        a = new Contract();
    }

    function testMiddle() public view {
        a.runMiddle();
    }
    function testBefore() public view {
        a.runBefore();
    }
    function testAfter() public view {
        a.runAfter();
    }
}
