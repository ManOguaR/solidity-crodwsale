// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "crowdsale/distribution/finalizableCrowdsale.sol";
import "crowdsale/abstractions/refundable.sol";

/**
 * @title RefundableCrowdsale
 * @dev Extension of `FinalizableCrowdsale` contract that adds a funding goal, and the possibility of users
 * getting a refund if goal is not met.
 *
 * Deprecated, use `RefundablePostDeliveryCrowdsale` instead. Note that if you allow tokens to be traded before the goal
 * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
 * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
 * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
 */
abstract contract RefundableCrowdsale is Context, FinalizableCrowdsale, RefundableContract {
    using SafeMath for uint256;

    /**
     * @dev Constructor, creates RefundEscrow.
     * @param inGoal Funding goal
     */
    constructor (uint256 inGoal, uint256 inOpeningTime, uint256 inClosingTime, uint256 inRate, address payable inWallet, IERC20 inToken) 
    FinalizableCrowdsale(inOpeningTime, inClosingTime, inRate, inWallet, inToken)
    RefundableContract(inGoal, inWallet) {}

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