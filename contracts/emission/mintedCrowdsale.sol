// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "contracts/crowdsale.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import {IMintable} from "solid-struct/contracts/tokens/mintable.sol";

/**
 * @title MintedCrowdsale
 * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
 * Token ownership should be transferred to MintedCrowdsale for minting.
 */
abstract contract MintedCrowdsale is Crowdsale, AccessControl {
    constructor(uint256 inRate, address payable inWallet, ERC20 inToken)
        Crowdsale(inRate, inWallet, inToken)
    {

    }
    
    /**
     * @dev Overrides delivery by minting tokens upon purchase.
     * @param beneficiary Token purchaser
     * @param tokenAmount Number of tokens to be minted
     */
    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal override  {
        // Potentially dangerous assumption about the type of the token.
        require(IMintable(address(token())).mint(beneficiary, tokenAmount), "MintedCrowdsale: minting failed");
    }
}