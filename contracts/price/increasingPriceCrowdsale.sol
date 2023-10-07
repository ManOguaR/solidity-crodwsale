// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "crowdsale/validation/timedCrowdsale.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title IncreasingPriceCrowdsale
 * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time.
 * Note that what should be provided to the constructor is the initial and final _rates_, that is,
 * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
 */
abstract contract IncreasingPriceCrowdsale is TimedCrowdsale {
    using SafeMath for uint256;

    uint256 private _initialRate;
    uint256 private _finalRate;

    /**
     * @dev Constructor, takes initial and final rates of tokens received per wei contributed.
     * @param inInitialRate Number of tokens a buyer gets per wei at the start of the crowdsale
     * @param inFinalRate Number of tokens a buyer gets per wei at the end of the crowdsale
     * @param inOpeningTime crowdsale opening time
     * @param inClosingTime crowdsale closing time
     * @param inWallet crowdsale wallet
     * @param inToken crowdsale token
     */
    constructor (uint256 inInitialRate,
        uint256 inFinalRate,
        uint256 inOpeningTime,
        uint256 inClosingTime,
        address payable inWallet,
        IERC20 inToken
    )
        TimedCrowdsale(inOpeningTime, inClosingTime, inInitialRate, inWallet, inToken)
        {
        require(inFinalRate > 0, "IncreasingPriceCrowdsale: final rate is 0");
        // solhint-disable-next-line max-line-length
        require(inInitialRate > inFinalRate, "IncreasingPriceCrowdsale: initial rate is not greater than final rate");
        _initialRate = inInitialRate;
        _finalRate = inFinalRate;
    }

    /**
     * @dev The base rate function is overridden to return the rate of tokens per wei at the present time.
     * Note that, as price _increases_ with time, the rate _decreases_.
     * @return The number of tokens a buyer gets per wei at a given time
     */
    function rate() public override view returns (uint256) {
        if (!isOpen()) {
            return 0;
        }

        // solhint-disable-next-line not-rely-on-time
        uint256 elapsedTime = block.timestamp.sub(openingTime());
        uint256 timeRange = closingTime().sub(openingTime());
        uint256 rateRange = _initialRate.sub(_finalRate);
        return _initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
    }

    /**
     * @return the initial rate of the crowdsale.
     */
    function initialRate() public view returns (uint256) {
        return _initialRate;
    }

    /**
     * @return the final rate of the crowdsale.
     */
    function finalRate() public view returns (uint256) {
        return _finalRate;
    }

    /**
     * @dev Overrides parent method taking into account variable rate.
     * @param weiAmount The value in wei to be converted into tokens
     * @return The number of tokens _weiAmount wei will buy at present time
     */
    function _getTokenAmount(uint256 weiAmount) internal override view returns (uint256) {
        uint256 currentRate = rate();
        return currentRate.mul(weiAmount);
    }
}