// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

contract Backend {
    enum OrderStatus {
        Created,
        Paid
    } // no ";" terminator

    struct Order {
        address buyer;
        address seller;
        uint256 amount;
        OrderStatus status;
    } // no ";" terminator

	// dynamic array ok in storage
	// "public" is bad here ... prefer custom getter this.getOrder(uint256);
    Order[] public orders; 

    // "indexed"
    event OrderCreated(uint256 indexed key, uint256 amount);

    error OnlyBuyerCanPay();
    error InsufficientPaymentAmount(uint256);
    error InvalidOrderStatus(OrderStatus);

    // API
    function createOrder(
        address buyer,
        address seller,
        uint256 amount
    ) external {
        // do not use "new"
        Order memory o = Order({
            buyer: buyer,
            seller: seller,
            amount: amount,
            status: OrderStatus.Created
        });

        orders.push(o);

        emit OrderCreated(orders.length - 1, amount);
    }

    function getOrder(uint256 index) external view returns (Order memory) {
        return orders[index];
    }

    function payment(uint256 orderIndex) external payable {
        Order storage o = orders[orderIndex];

        if (msg.sender != o.buyer) revert OnlyBuyerCanPay();
        if (msg.value != o.amount) revert InsufficientPaymentAmount(msg.value);
        if (o.status == OrderStatus.Paid) revert InvalidOrderStatus(o.status);

        // ok, bc we said "storage" above.
        payable(o.seller).transfer(msg.value);
        o.status = OrderStatus.Paid;
    }

    function orderCount() external view returns (uint256) {
        return orders.length;
    }
}

contract TestFulfillment is Test {
    Backend be;
    address buyer;
    address seller;
    uint value = 2 ether;

    function setUp() public {
        be = new Backend();
        buyer = address(1);
        seller = address(2);
    }

    function testCreateOrder() public {
        be.createOrder(buyer, seller, value);
        assertEq(be.orderCount(), 1);
        (
            address _buyer,
            address _seller,
            uint256 _amount,
            Backend.OrderStatus status // we have access to the contracts enums
        ) = be.orders(0);

        // enum must be cast to uint8
        assertEq(uint8(status), uint8(Backend.OrderStatus.Created));

        // other types here are ok.
        assertEq(_amount, value);
        assertEq(_buyer, buyer);
        assertEq(_seller, seller);
    }

    function testAccessPublicOrdersRequiresDestructuring() public {
        be.createOrder(buyer, seller, value);

        assertEq(be.orderCount(), 1);
        (
            address _buyer,
            address _seller,
            uint256 _amount,
            Backend.OrderStatus status // we have access to the contracts enums
        ) = be.orders(0);

        assertEq(buyer, _buyer);
        assertEq(seller, _seller);
        assertEq(_amount, value);
        assertEq(uint8(status), uint8(Backend.OrderStatus.Created));
    }

    function testAccessOrderViaGetOrderCustomReturnsStruct() public {
        be.createOrder(buyer, seller, value);

		// this is much cleaner.
        Backend.Order memory order = be.getOrder(0);

        assertEq(buyer, order.buyer);
        assertEq(seller, order.seller);
        assertEq(value, order.amount);
        assertEq(uint8(Backend.OrderStatus.Created), uint8(order.status));
    }

    function testSellerCannotMakePayment() public {
        hoax(seller);
        vm.expectRevert();
        be.payment(value);
    }

    function testBuyerCanMakePayment() public {
        be.createOrder(buyer, seller, value);

        hoax(buyer);
        be.payment{value: 2 ether}(0);
		Backend.Order memory o = be.getOrder(0);

        assertEq(uint8(o.status), uint8(Backend.OrderStatus.Paid));
    }

    function testBuyerCannotMakePaymentOnPaidOrder() public {
        be.createOrder(buyer, seller, value);

        hoax(buyer);
        be.payment{value: 2 ether}(0);
		Backend.Order memory o = be.getOrder(0);
        assertEq(uint8(o.status), uint8(Backend.OrderStatus.Paid));

        vm.expectRevert(); // must be directly before reverting fn
        be.payment{value: 2 ether}(0);
    }

    function testBuyerMustMakeFullPayment() public {
        be.createOrder(buyer, seller, value);

        hoax(buyer);

        vm.expectRevert(); // must be directly before reverting fn
        be.payment{value: value - 10 wei}(0);

        vm.expectRevert(); // must be directly before reverting fn
        be.payment{value: value + 10 wei}(0);

		Backend.Order memory o = be.getOrder(0);
        assertEq(uint8(o.status), uint8(Backend.OrderStatus.Created));
    }

    function testSellerReceivesPayment() public {
        be.createOrder(buyer, seller, value);

        hoax(buyer);
        uint256 sellerInitialBalance = seller.balance;

        be.payment{value: 2 ether}(0);
		Backend.Order memory o = be.getOrder(0);

        assertEq(uint8(o.status), uint8(Backend.OrderStatus.Paid));
        assertEq(o.seller.balance, sellerInitialBalance + 2 ether);
    }
}
