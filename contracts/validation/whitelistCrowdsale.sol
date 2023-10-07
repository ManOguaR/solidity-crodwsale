// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "../crowdsale.sol";

/**
 * @title WhitelistCrowdsale
 * @dev Crowdsale in which only whitelisted users can contribute.
 */
abstract contract WhitelistCrowdsale is Crowdsale, AccessControl {
    bytes32 public constant WHITELISTED_ROLE = keccak256("WHITELISTED_ROLE");
    bytes32 public constant WHITELIST_ADMIN_ROLE = keccak256("WHITELIST_ADMIN_ROLE");

    constructor (uint256 inRate, address payable inWallet, IERC20 inToken)
        Crowdsale(inRate, inWallet, inToken)
    {
        _grantRole(WHITELIST_ADMIN_ROLE, inWallet);
    }
    
    function addToWhitelist(address candidate) public onlyRole(WHITELIST_ADMIN_ROLE)
    {
        _grantRole(WHITELISTED_ROLE, candidate);
    }

    function addToWhitelist(address[] memory addresses) public onlyRole(WHITELIST_ADMIN_ROLE) {
        for (uint i = 0; i < addresses.length; i++) {
            // Perform some operation on each element of the array
            _grantRole(WHITELISTED_ROLE, addresses[i]);
        }
    }

    function removeFromWhitelist(address candidate) public onlyRole(WHITELIST_ADMIN_ROLE)
    {
        _revokeRole(WHITELISTED_ROLE, candidate);
    }
    
    function removeFromWhitelist(address[] memory addresses) public onlyRole(WHITELIST_ADMIN_ROLE) {
        for (uint i = 0; i < addresses.length; i++) {
            // Perform some operation on each element of the array
            _revokeRole(WHITELISTED_ROLE, addresses[i]);
        }
    }

    /**
     * @dev Extend parent behavior requiring beneficiary to be whitelisted. Note that no
     * restriction is imposed on the account sending the transaction.
     * @param _beneficiary Token beneficiary
     * @param _weiAmount Amount of wei contributed
     */
    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal override view {
        require(hasRole(WHITELISTED_ROLE, _beneficiary), "WhitelistCrowdsale: beneficiary doesn't have the Whitelisted role");
        super._preValidatePurchase(_beneficiary, _weiAmount);
    }
}