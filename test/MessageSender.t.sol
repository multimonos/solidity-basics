// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test,console} from "forge-std/Test.sol";

contract MessageSender {

	function senderAvailableInPrivateFn() public view returns(bool){
		address sender = msg.sender;
		return _checkSenderIs(sender);
	}

	function _checkSenderIs(address _sender) private view returns(bool) {
		return msg.sender == _sender;
	}
}

contract MessageSenderTests is Test {

	function testMessageSenderAvailableInContext() public {
		MessageSender ms = new MessageSender();

		vm.prank(address(3));

		bool senderAvailableInPrivateFn = ms.senderAvailableInPrivateFn();

		assertTrue(senderAvailableInPrivateFn);
	}
}