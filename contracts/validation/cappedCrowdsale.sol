// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "solid-struct/contracts/math/SafeMath.sol";
import "../crowdsale.sol";

/**
 * @title CappedCrowdsale
 * @dev Crowdsale with a limit for total contributions.
 */
abstract contract CappedCrowdsale is Crowdsale {
    using SafeMath for uint256;

    uint256 private _cap;

    /**
     * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
     * @param inCap Max amount of wei to be contributed
     * @param inRate The rate of the crowdsale
     * @param inWallet The wallet address to receive the funds
     * @param inToken The token contract address
     */
    constructor (uint256 inCap, uint256 inRate, address payable inWallet, IERC20 inToken) 
        Crowdsale(inRate, inWallet, inToken) 
    {
        require(inCap > 0, "CappedCrowdsale: cap is 0");
        _cap = inCap;
    }


    /**
     * @return the cap of the crowdsale.
     */
    function cap() public view returns (uint256) {
        return _cap;
    }

    /**
     * @dev Checks whether the cap has been reached.
     * @return Whether the cap was reached
     */
    function capReached() public view returns (bool) {
        return weiRaised() >= _cap;
    }

    /**
     * @dev Extend parent behavior requiring purchase to respect the funding cap.
     * @param beneficiary Token purchaser
     * @param weiAmount Amount of wei contributed
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal override view {
        super._preValidatePurchase(beneficiary, weiAmount);
        require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
    }
}