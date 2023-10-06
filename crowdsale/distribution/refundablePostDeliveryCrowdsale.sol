// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "crowdsale/crowdsale.sol";
import "crowdsale/abstractions/refundable.sol";
import "crowdsale/abstractions/finalizable.sol";
import "crowdsale/distribution/postDeliveryCrowdsale.sol";

/**
 * @title RefundablePostDeliveryCrowdsale
 * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
 * once the crowdsale has closed and the goal met, preventing refunds to be issued
 * to token holders.
 */
contract RefundablePostDeliveryCrowdsale is PostDeliveryCrowdsale, RefundableContract, FinalizableContract {
    constructor(
        uint256 inGoal,
        uint256 inOpeningTime,
        uint256 inClosingTime,
        uint256 inRate,
        address payable inWallet,
        IERC20 inToken
        )
        PostDeliveryCrowdsale(inOpeningTime, inClosingTime, inRate, inWallet, inToken)
        RefundableContract(inGoal, inWallet)
        FinalizableContract()
        {
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
    function _finalization() internal override {
        if (goalReached()) {
            _closeAndWithdraw();
        } else {
            _enableRefunds();
        }

        super._finalization();
    }

    /**
     * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
     */
    function _forwardFunds() internal virtual override  {
        _depositInEscrow();
    }
}