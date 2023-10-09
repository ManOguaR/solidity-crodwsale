// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "contracts/crowdsale.sol";
import "contracts/distribution/postDeliveryCrowdsale.sol";
import { Refundable } from "solid-struct/contracts/context/refundable.sol";
import { Finalizable } from "solid-struct/contracts/abstractions/finalizable.sol";

/**
 * @title RefundablePostDeliveryCrowdsale
 * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
 * once the crowdsale has closed and the goal met, preventing refunds to be issued
 * to token holders.
 */
abstract contract RefundablePostDeliveryCrowdsale is PostDeliveryCrowdsale, Refundable, Finalizable {
    // minimum amount of funds to be raised in weis
    uint256 private _goal;

    constructor(
        uint256 inGoal,
        uint256 inOpeningTime,
        uint256 inClosingTime,
        uint256 inRate,
        address payable inWallet,
        IERC20 inToken
        )
        PostDeliveryCrowdsale(inOpeningTime, inClosingTime, inRate, inWallet, inToken)
        Refundable(inWallet)
        Finalizable(){
            require(inGoal > 0, "RefundableCrowdsale: goal is 0");
            _goal = inGoal;
        }

    /**
     * @return minimum amount of funds to be raised in wei.
     */
    function goal() public view returns (uint256) {
        return _goal;
    }

    function withdrawTokens(address beneficiary) public override {
        require(finalized(), "RefundablePostDeliveryCrowdsale: not finalized");
        require(goalReached(), "RefundablePostDeliveryCrowdsale: goal not reached");

        super.withdrawTokens(beneficiary);
    }

    /**
     * @dev Investors can claim refunds here if crowdsale is unsuccessful.
     * @param refundee Whose refund will be claimed.
     */
    function claimRefund(address payable refundee) public {
        require(finalized(), "RefundableCrowdsale: not finalized");
        require(!goalReached(), "RefundableCrowdsale: goal reached");
        _claimRefund(refundee);
    }

    /**
     * @dev Checks whether funding goal was reached.
     * @return Whether funding goal was reached
     */
    function goalReached() public view returns (bool) {
        return weiRaised() >= goal();
    }

    /**
     * @dev Escrow finalization task, called when finalize() is called.
     */
    function _finalization() internal override returns (bool) {
        if (goalReached()) {
            _closeAndWithdraw();
        } else {
            _enableRefunds();
        }
        return super._finalization();
    }

    /**
     * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
     */
    function _forwardFunds() internal virtual override  {
        _depositInEscrow();
    }
}