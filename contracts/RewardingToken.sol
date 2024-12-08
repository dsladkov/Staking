// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Burnable.sol";
import "./Errors.sol";

contract RewardingToken is ERC20Burnable {
    address private _owner;

    error NotAnOwner(address addr);

    modifier onlyOwner() {
        require(_owner == _msgSender(), Errors.NotAnOwner(msg.sender));
        _;
    }

    constructor(address initialOwner) ERC20("RewardingToken", "RW") {
        _owner = initialOwner;
        _mint(msg.sender, 10000 * 10 ** decimals()); //10000 * 10 ^ 18
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}