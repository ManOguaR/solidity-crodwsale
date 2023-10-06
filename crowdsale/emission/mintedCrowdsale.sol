// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "crowdsale/crowdsale.sol";
import "crowdsale/abstractions/mintable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title MintedCrowdsale
 * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
 * Token ownership should be transferred to MintedCrowdsale for minting.
 */
contract MintedCrowdsale is Crowdsale {
    constructor(uint256 inRate, address payable inWallet, ERC20 inToken)
        Crowdsale(inRate, inWallet, inToken)
    {}
    
    /**
     * @dev Overrides delivery by minting tokens upon purchase.
     * @param beneficiary Token purchaser
     * @param tokenAmount Number of tokens to be minted
     */
    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal override  {
        // Potentially dangerous assumption about the type of the token.
        require(ERC20Mintable(address(token())).mint(beneficiary, tokenAmount), "MintedCrowdsale: minting failed");
    }
}