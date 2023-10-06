// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IMintable {
    function mint(address to, uint256 amount) external returns (bool);
}

abstract contract ERC20Mintable is ERC20, IMintable {
    
    function mint(address to, uint256 amount) public override returns (bool) {
        _mint(to, amount);
        return  true;
    }
}