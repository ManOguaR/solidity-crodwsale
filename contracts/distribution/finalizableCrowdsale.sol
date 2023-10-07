// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "contracts/validation/timedCrowdsale.sol";
import { FinalizableContract } from "solid-struct/contracts/abstractions/finalizable.sol";

/**
 * @title FinalizableCrowdsale
 * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
 * can do extra work after finishing.
 */
abstract contract FinalizableCrowdsale is TimedCrowdsale, FinalizableContract {
    using SafeMath for uint256;

    /**
     * @dev Constructor, takes crowdsale opening and closing times.
     * @param inOpeningTime Crowdsale opening time
     * @param inClosingTime Crowdsale closing time
     * @param inRate Crowdsale rate
     * @param inWallet Crowdsale wallet
     * @param inToken Crowdsale token
     */
    constructor (uint256 inOpeningTime, uint256 inClosingTime, uint256 inRate, address payable inWallet, IERC20 inToken) 
    TimedCrowdsale(inOpeningTime, inClosingTime, inRate, inWallet, inToken)
    FinalizableContract() {
    }

    /**
     * @dev Must be called after crowdsale ends, to do some extra finalization
     * work. Calls the contract's finalization function.
     */
    function finalize() public override {
        require(hasClosed(), "FinalizableCrowdsale: not closed");
        super.finalize();
    }
}