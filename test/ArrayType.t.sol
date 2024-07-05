// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

/**
When talking about array,

	calldata : is read only
	memory   : read/write on copy 
	storage  : read/write on reference 
 */
contract PassByReference {
    uint[3] public nums;

    constructor() {
        nums[0] = 1;
        nums[1] = 2;
        nums[2] = 3;
    }

    function modifyEffect() public {
        modifyWithSideEffectsIfStorage(nums);
    }

    function modifyWithSideEffectsIfStorage(
        uint[3] storage numberList
    ) private {
        numberList[1] = 666;
    }

    function modifyNoEffectIfMemory() public view {
        modifyCopy(nums);
    }

    function modifyCopy(uint[3] memory numberList) private pure {
        // bc this is "memory" we are not modifying storage, so, it's "pure"
        numberList[1] = 720;
    }

    function getSecond() public view returns (uint) {
        return nums[1];
    }
}

contract StorageArrayHasPush {
    uint[] evens;

    function keepEvens(uint[] memory nums) external {
        for (uint i = 0; i < nums.length; i++) {
            if (nums[i] % 2 == 0) {
                evens.push(nums[i]);
            }
        }
    }
}

contract MemoryArrayDoesNotHavePushMethod {
    function keepEvens(
        uint[] memory nums
    ) external pure returns (uint[] memory) {

        uint count = 0;
        for (uint i = 0; i < nums.length; i++) {
            if (nums[i] % 2 == 0) count++;
        }

        uint[] memory evens = new uint[](count);

        if (count == 0) return evens;

        uint n = 0;
        for (uint i = 0; i < nums.length; i++) {
            if (nums[i] % 2 == 0) {
                evens[n++] = nums[i];
            }
        }

        return evens;
    }
}

contract TestArrays is Test {
    uint[] a; // STORAGE SCOPE

    function testPushAllowedOnDynamicArrayInStorage() public {
        // uint[] memory a; // FAILS
        // this is NOT best practice
        a.push(1);
        a.push(2);
        a.push(3);
        a.push(4);
        assertEq(a.length, 4);
    }

    function testIndexedAccessOnlyForFixedArray() public pure {
        uint[3] memory b;
        //b.push(1); // FAILS
        b[0] = 10;
        b[1] = 11;
        b[2] = 12;
        assert(b.length == 3);
    }

    function testPassByReference() public {
        PassByReference pbr = new PassByReference();

        uint s0 = pbr.getSecond();
        assertEq(s0, 2);

        pbr.modifyEffect();

        uint s1 = pbr.getSecond();
        assertEq(s1, 666);
    }

    function testPassByValue() public {
        PassByReference pbr = new PassByReference();

        uint s0 = pbr.getSecond();
        assertEq(s0, 2);

        pbr.modifyNoEffectIfMemory();

        uint s1 = pbr.getSecond();
        assertEq(s1, 2);
    }
}
