// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

interface Errors {
  error NotAnOwner(address _addr);
  error InsufficientBalanceExchange(uint256 currentBalance, uint256 requestedAmount);
  error ItemIsOutOfStock();
  error InsufficientItemQuantity(uint256 availableQty, uint256 requestedQty);
}