// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test,console} from "forge-std/Test.sol";

contract A {

	uint8 public count = 0;

	fallback() external {
		console.log("fallback called");
		count++;
	}
}	

contract B {

	address other;

	constructor(address _other) {
		other = _other;
	}

	function trigger() public {
		bytes32 foobar = keccak256("foobar()");
		(bool success,) = other.call(abi.encodePacked(foobar));
		require(success);
	}

}


contract TestFallback is Test{

	function testFallbackTrigger() public {
		A a = new A();
		B b = new B(address(a));
		b.trigger();
		assertEq(a.count(),1);
		b.trigger();
		assertEq(a.count(),2);
	}

}