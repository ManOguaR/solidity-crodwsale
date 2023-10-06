// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "crowdsale/validation/timedCrowdsale.sol";

/**
 * @title FinalizableCrowdsale
 * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
 * can do extra work after finishing.
 */
abstract contract FinalizableContract {
    using SafeMath for uint256;

    bool private _finalized;

    event ContractFinalized();

    /**
     * @dev Constructor, takes crowdsale opening and closing times.
     */
    constructor () 
    {
    _finalized = false;
    }

    /**
     * @return true if the crowdsale is finalized, false otherwise.
     */
    function finalized() public view returns (bool) {
        return _finalized;
    }

    /**
     * @dev Must be called after crowdsale ends, to do some extra finalization
     * work. Calls the contract's finalization function.
     */
    function finalize() public virtual  {
        require(!_finalized, "FinalizableCrowdsale: already finalized");
        _finalized = true;

        _finalization();
        emit ContractFinalized();
    }

    /**
     * @dev Can be overridden to add finalization logic. The overriding function
     * should call super._finalization() to ensure the chain of finalization is
     * executed entirely.
     */
    function _finalization() virtual internal {
        // solhint-disable-previous-line no-empty-blocks
    }
}