# DeFi Insurance Protocol

## Overview
- Purpose: insure smart contracts against specific risks.
- Core idea: pool premiums to cover verified claims.

## Why It Matters
- Reduces user risk when interacting with smart contracts.
- Encourages safer adoption of DeFi products.

## Learn
### Risk Pooling
- Many contributors pay small premiums into a shared pool.
- Losses are spread across the pool to reduce individual impact.
- Pool health depends on pricing risk accurately and maintaining reserves.

### Real-World DeFi Use Cases
- Smart contract bug coverage for lending protocols.
- Stablecoin depeg protection.
- Oracle failure or manipulation coverage.
- Bridge exploit coverage for cross-chain users.

## Claim Verification (High-Level)
- Trigger: a defined on-chain or off-chain event occurs.
- Evidence: collect proof of the event (transaction data, oracle reports).
- Validation: check policy terms and confirm the event matches covered risk.
- Decision: approve or deny based on verification results.
- Payout: distribute funds from the pool to approved claimants.

## Next Steps
- Define covered risks and exclusions.
- Specify premium pricing model and reserve targets.
- Outline governance or automation for claim decisions.

## Quick Start
1. Install dependencies: `npm install`
2. Compile contracts: `npm run compile`

## Contract Overview
The `InsurancePool` contract supports:
- Policy purchase with a quoted premium.
- Pool funding via direct deposits.
- Claim submission and owner review.
- Payouts from the pooled balance.

Key state variables:
- `totalPremiums`: total premiums collected.
- `totalPayouts`: total payouts made.
- `totalCoverageActive`: active coverage outstanding.

## Minimal Flow
1. Owner deploys `InsurancePool` with a yearly premium rate in basis points.
2. User calls `quotePremium` and then `createPolicy` with the exact premium.
3. User calls `submitClaim` with evidence metadata.
4. Owner calls `reviewClaim` and then anyone can call `payoutClaim`.
