# Distributed-Liquidity-Pool
A pooled fund which services liquidity on DEX's.

One of the major barriers to adoption for decentralized exchanges is limited liquidity as a result of being largely peer-to-peer. The Distributed Liquidity Pool (DLP) is an infrastructure layer on top of Decentralized exchanges which allows many users to collectively become liquidity providers.

For this process to run efficiently there will likely be one party which is responsible for implementing the trading strategy whilst other parties will play a more passive role though providing funds and governance. The DLP will provide the infrastructure for fund creation, contributions, incentive schemes, payouts and trading on DEX's.

Broadly this can be split into two main components; fund management, and DEX integration.

### [Unit Tests.](https://github.com/Canal-Protocol/dlp-Kyber-test-suite)

### [Front End.](https://github.com/ads365/canalfrontend/blob/master/README.md)

**Please Note that this entire repository is a work in progress.** 

## Components

### Fund Management
The first iteration of fund management will be a [Fund Wallet](https://github.com/Canal-Protocol/Distributed-Liquidity-Pool/blob/master/Smart%20Contracts/FundWallet.sol) which will be responsible for the following functions: fund creation, contribution, incentive schemes, and payouts. Please note that the modifiers and relevant variables are now stored in [FwPermissions.sol](https://github.com/Canal-Protocol/Distributed-Liquidity-Pool/blob/master/Smart%20Contracts/FwPermissions.sol) - this was done for building more complete tests.

### DEX Integration
Our integration for the above will be with [Kyber Network](https://kyber.network/). The fund wallet will act as a feed to [Kyber Fund Reserve](https://github.com/Canal-Protocol/Distributed-Liquidity-Pool/tree/master/Smart%20Contracts/Kyber%20Fund%20Reserve) which is based on Kyber's original Reserve, with additional functionailty that allows for it push and pull funds from the Fund Wallet.

