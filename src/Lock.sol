pragma solidity ^0.8.0;

contract Lock {
    receive() external payable {
        revert();
    }
}
