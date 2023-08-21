// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/FriendtechSharesV1.sol";
import "../src/Lock.sol";

contract LockTest is Test {
    FriendtechSharesV1 shares;
    Lock lock;

    function setUp() public {
        shares = new FriendtechSharesV1();
        lock = new Lock();

        vm.deal(address(0xDEAD), 100 ether);

        // set EOA
        shares.setFeeDestination(address(0xBEEF));
    }

    function testLock() public {
        vm.startPrank(address(0xDEAD));
        // can buy shares
        shares.buyShares{value: 1 ether}(address(0xDEAD), 1);
        shares.buyShares{value: 1 ether}(address(0xDEAD), 10);
        // can sell shares
        shares.sellShares(address(0xDEAD), 1);
        vm.stopPrank();

        // set blocking contract
        vm.prank(address(this));
        shares.setFeeDestination(address(lock));

        // can't sell shares anymore due to protocolFeeDestination revert
        vm.prank(address(0xDEAD));
        shares.sellShares(address(0xDEAD), 1);

    }
}
