
pragma solidity ^0.8.3;

import "./ERC20Standart.sol";

contract TLP is ERC20Standard {
        constructor() public {
            totalSupply = 10000000000000;
            name = "Test Lesson Purse coin";
            decimals = 4;
            symbol = "TLP";
            version = "1.0";
            balances[msg.sender] = totalSupply;
        }
}