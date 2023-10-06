// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/security/Pausable.sol";
import "crowdsale/crowdsale.sol";

/**
 * @title PausableCrowdsale
 * @dev Extension of Crowdsale contract where purchases can be paused and unpaused by the pauser role.
 */
contract PausableCrowdsale is Crowdsale, Pausable {
    constructor(uint256 inRate, address payable inWallet, IERC20 inToken) 
    Crowdsale(inRate, inWallet, inToken) {
    }
    /**
     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
     * Use super to concatenate validations.
     * Adds the validation that the crowdsale must not be paused.
     * @param _beneficiary Address performing the token purchase
     * @param _weiAmount Value in wei involved in the purchase
     */
    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal override view whenNotPaused {
        return super._preValidatePurchase(_beneficiary, _weiAmount);
    }
}