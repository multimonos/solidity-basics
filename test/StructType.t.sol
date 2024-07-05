// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

contract Backend {
    enum OrderStatus {
        Created,
        Paid
    }

    struct Order {
        address buyer;
        address seller;
        uint amount;
        OrderStatus status;
    }

    Order[] public orders;

    function createOrder(address buyer, address seller, uint amount) external {
        Order memory o = Order({
            buyer: buyer,
            seller: seller,
            amount: amount,
            status: OrderStatus.Created
        });

        orders.push(o);
    }

    function getOrder(uint index) external view returns (Order memory) {
        return orders[index];
    }

    function markPaid(uint key) external {
        orders[key].status = OrderStatus.Paid;
    }

    function _wasPaid(Order storage _order) internal view returns(bool) {
        return _order.status == OrderStatus.Paid;
    }

    function wasPaid(uint key) external view returns(bool) {
        Order storage order = orders[key];
        return _wasPaid(order);
    }
}

struct Person {
    address uri;
    bool alive;
}

contract TestStructs is Test {
    function testCreateImplicitly() public pure {
        Person memory p = Person(address(3), true);

        assertEq(p.uri, address(3));
        assertEq(p.alive, true);
    }

    function testCreateExplicitly() public pure {
        Person memory p = Person({uri: address(2), alive: false});

        assertEq(p.uri, address(2));
        assertEq(p.alive, false);
    }

    function testReferencingStructsInContracts() public pure {
        Backend.Order memory o = Backend.Order({
            buyer: address(0),
            seller: address(1),
            amount: 2 ether,
            status: Backend.OrderStatus.Created
        });

        assertEq(o.buyer, address(0));
        assertEq(o.seller, address(1));
        assertEq(o.amount, 2 ether);
        assertEq(uint8(o.status), uint8(Backend.OrderStatus.Created));
    }

    function testDestructuringReturnValue() public {
        // when accessing a public storage of struct, the returned object,
        // must be destructured into a tuple.
        Backend backend = new Backend();
        backend.createOrder(address(0), address(1), 2 ether);

        (
            address _buyer,
            address _seller,
            uint _amount,
            Backend.OrderStatus _status
        ) = backend.orders(0);

        assertEq(_buyer, address(0));
        assertEq(_seller, address(1));
        assertEq(_amount, 2 ether);
        assertEq(uint8(_status), uint8(Backend.OrderStatus.Created));
    }

    function testPartialDestructuringReturnValue() public {
        Backend backend = new Backend();
        backend.createOrder(address(0), address(1), 2 ether);

        (, address _seller, , Backend.OrderStatus _status) = backend.orders(0);

        assertEq(_seller, address(1));
        assertEq(uint8(_status), uint8(Backend.OrderStatus.Created));
    }

    function testTypedReturnValue() public {
        Backend backend = new Backend();
        backend.createOrder(address(0), address(1), 2 ether);

        Backend.Order memory o = backend.getOrder(0);

        assertEq(o.buyer, address(0));
        assertEq(o.seller, address(1));
        assertEq(o.amount, 2 ether);
        assertEq(uint8(o.status), uint8(Backend.OrderStatus.Created));
    }

    function testPassByReference() public {
        Backend backend = new Backend();
        backend.createOrder(address(0), address(1), 2 ether);
        backend.markPaid(0);

        Backend.Order memory o = backend.getOrder(0);

        assertEq(o.buyer, address(0));
        assertEq(o.seller, address(1));
        assertEq(o.amount, 2 ether);
        assertEq(uint8(o.status), uint8(Backend.OrderStatus.Paid));
        assertTrue(backend.wasPaid(0));
    }
}

