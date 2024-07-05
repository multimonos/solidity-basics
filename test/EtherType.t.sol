// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";


contract Deposit {

	error IncorrectAmount(uint256);

	function deposit() external payable {
		if(msg.value != 1 ether) revert IncorrectAmount(msg.value);
	}

}


contract EtherType is Test {

	Deposit c;
	error IncorrectAmount(uint256);

	function setUp() public {
		c = new Deposit();
	}

	function testWei() public pure{
		uint256 a = 1 ether;
		uint256 b = 1e18 wei;
		assertEq(a,b);
	}

	function testDepositSuccess() public  {
		c.deposit{value: 1 ether}();
		assertTrue(true,"it's ok to deposit 1 ether");
	}

	function testDepositFailed() public {
		vm.expectRevert();
		c.deposit{value: 1 ether + 1 wei}();

		vm.expectRevert();
		c.deposit{value: 1 ether - 1 wei}();
	}

	function testAmountOfFailedDeposit() public{
		vm.expectRevert(
			abi.encodeWithSelector(IncorrectAmount.selector, 5 )
		);
		c.deposit{value:5}();

		vm.expectRevert(
			abi.encodeWithSelector(IncorrectAmount.selector, 5 ether)
		);
		c.deposit{value:5 ether}();


	}
}