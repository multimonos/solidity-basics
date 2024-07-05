// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

contract LoggingTest is Test {

	function testLogBool() public view {
		console.log(true);
		console.logBool(false);
	}

	function testLogUnsignedInteger() public view {
		uint a = 42;
		console.log(a);

		uint b = 5;
		console.logUint(b); 
	}
	function testLogInteger() public view {
		int a = 42;
		// console.log(a); // fails
		// console.log(-a); // fails
		console.log(3);
		console.logInt(a);
		console.logInt(-a);  
	}

	function testLogString() public view {
		console.log("a string");
		console.log("a second string");
	}

}