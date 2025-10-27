// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract anthonyToken is ERC20 {
    constructor() ERC20("anthonyToken", "ATN") {
        _mint(msg.sender, 50 * 10 ** decimals());
    }
}
