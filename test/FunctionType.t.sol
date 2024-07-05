// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

contract FunctionTypes {
    string readOnly = "Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.";

    function readString() external view returns(string memory){
        return readOnly;
    }

}

contract FunctionTypesTest is Test {
    FunctionTypes f;

    function setUp() public{
        f = new FunctionTypes();
    }

    function double(uint a) public pure returns (uint) {
        return a + a;
    }

    function double(uint a, uint b) public pure returns (uint, uint) {
        return (a + a, b + b);
    }

    function testFn() public pure {
        uint a = double(2);
        assertEq(a, 4);
    }

    function testOverrideFn() public pure {
        (uint a, uint b) = double(2, 3);
        assertEq(a, 4);
        assertEq(b, 6);
    }

    function testExternalView() public  {
        // vm.prank(address(3));
        hoax(address(4));
        f.readString();
    }
}
