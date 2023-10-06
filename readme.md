# solidity-crowdsale
Thre are a set of solidity contracts that can be used to create a crowdsale for a token.
The contracts are based on the old OpenZeppelin 2.5.1 contracts, but updated to use the
latest OpenZeppelin 5.0.0 contracts.

## why
Because the old OpenZeppelin 2.5.1 contracts are not compatible with the latest solidity
and I am in need of some contracts to create a crowdsale for a token... Then I ended up
upgrading it all and decided to share it with the world.

### known limitations
Very limited access control. You must implement your own access control for the crowdsale
if you want to use full OpenZeppelin 5.0.0 access control features.

## how to use
Directly override the contract you want to use, functionallity is the same as the old
OpenZeppelin 2.5.1 contracts.

The contracts are:


	└-crowdsale
		|- crowdsale.sol: base contract for managing a token crowdsale.
		|-abstractions
		|	|- finalizable.sol: extension where a contract can be finalized.
		|	|- mintable.sol: ERC20 mintable token utility.
		|	|- refundable.sol: extension where a transacton can be refunded by Escrow.
		|	└- secondary.sol: used as secondary Context. 
		|-distribution
		|	|- finalizableCrowdsale.sol: adds finalization logic to a crowdsale.
		|	|- postDeliveryCrowdsale.sol: adds post delivery logic to a crowdsale.
		|	|- refundableCrowdsale.sol: adds refund logic to a crowdsale.
		|	└- refundablePostDeliveryCrowdsale.sol: adds refund and finalization logic to a post delivery crowdsale.
		|-emission
		|	|- allowanceCrowdsale.sol: adds token allowance logic to a crowdsale.
		|	└- mintedCrowdsale.sol: adds minting logic to a crowdsale.
		|-price
		|	└- increasingPriceCrowdsale.sol: adds increasing price logic to a crowdsale.
		└-validation
			|- finalizableCrowdsale.sol: adds finalization logic to a crowdsale.
			|- postDeliveryCrowdsale.sol: adds post delivery logic to a crowdsale.
			|- timedCrowdsale.sol: adds timed logic to a crowdsale.
			└- whitelistedCrowdsale.sol: adds whitelisting logic to a crowdsale.

And remember:
[@ManOguaR](https://www.github.com/ManOguaR) rules!