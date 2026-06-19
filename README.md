
# DeFi Insurance Protocol

[![Solidity](https://img.shields.io/badge/Solidity-^0.8.0-363636?logo=solidity)](https://soliditylang.org)
[![Hardhat](https://img.shields.io/badge/Built%20with-Hardhat-FF9900)](https://hardhat.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**A decentralized insurance protocol for DeFi smart contracts.**  
Protect users against smart contract failures, exploits, oracle manipulations, stablecoin depegs, and bridge risks through a transparent, community-driven risk pool.

---

## 📋 Overview

The **DeFi Insurance Protocol** enables users to purchase coverage for specific DeFi risks by paying premiums into a shared liquidity pool. Validated claims are paid out from the pool, spreading risk across all participants.

This protocol brings traditional insurance principles — **risk pooling**, **actuarial pricing**, and **claims verification** — to the blockchain in a trust-minimized, permissionless manner.

### Core Principles
- **Capital Efficiency**: Premiums are actively managed in the pool.
- **Transparency**: All policies, premiums, and claims are on-chain.
- **Decentralization**: Moving toward fully automated, governance-driven claim validation.
- **User Protection**: Reduces systemic risk and builds confidence in DeFi.

---

## ✨ Key Features

- **Flexible Policy Creation** — Users can purchase coverage for custom durations and coverage amounts.
- **Dynamic Premium Quoting** — Risk-based pricing using basis points and coverage parameters.
- **On-Chain Risk Pool** — Single pooled capital model for maximum efficiency.
- **Claim Submission & Verification** — Structured workflow with evidence metadata.
- **Governance Ready** — Designed for future DAO-controlled claim decisions and parameter updates.
- **Auditable & Transparent** — Every action is verifiable on the blockchain.

---

## 🛠 Architecture

### Main Contracts

| Contract            | Description                                      |
|---------------------|--------------------------------------------------|
| `InsurancePool.sol` | Core contract managing pool, policies, and claims |
| `PolicyManager.sol` | (Planned) Policy NFT issuance and tracking       |
| `RiskOracle.sol`    | (Planned) Trusted oracle integration for events  |
| `Governance.sol`    | (Future) DAO governance module                   |

### Key State Variables (InsurancePool)
- `totalPremiums` — Total premiums collected
- `totalPayouts` — Total claims paid out
- `totalCoverageActive` — Currently active coverage
- `premiumRate` — Base yearly rate in basis points
- `reserveTarget` — Minimum reserve ratio target

---

## 📊 How It Works

### 1. Risk Pooling
Multiple users contribute small premiums → large shared capital pool. Losses are socialized across participants.

### 2. Policy Lifecycle
1. **Quote** → User requests premium for desired coverage amount and duration.
2. **Purchase** → Pay exact premium and receive policy confirmation.
3. **Active Coverage** → Protection is live for the chosen period.
4. **Claim** → Submit evidence if a covered event occurs.
5. **Review & Payout** → Verified claims are paid from the pool.

### 3. Supported Risks (Current & Planned)
- Smart contract exploits / bugs
- Oracle failures or manipulation
- Stablecoin depeg events
- Cross-chain bridge hacks
- Governance attacks
- Liquidation failures (in lending protocols)

---

## 🚀 Quick Start

### Prerequisites
- Node.js ≥ 18
- Yarn or npm
- Hardhat

### Installation

```bash
git clone https://github.com/Ashfaque965/DeFi-Insurance-Protocol.git
cd DeFi-Insurance-Protocol
npm install
```

### Compile & Test

```bash
# Compile contracts
npm run compile

# Run tests
npm test

# Test with coverage
npm run coverage
```

### Local Development

```bash
# Start local Hardhat network
npm run node

# Deploy to local network (in new terminal)
npm run deploy:local
```

---

## 📖 Usage Examples

### 1. Deploy Pool (Owner)

```solidity
// 500 = 5% yearly premium rate (in basis points)
InsurancePool pool = new InsurancePool(500);
```

### 2. Create Policy (User)

```javascript
const premium = await pool.quotePremium(coverageAmount, durationInDays);
await pool.createPolicy(coverageAmount, durationInDays, { value: premium });
```

### 3. Submit Claim

```javascript
await pool.submitClaim(policyId, evidenceHash, description);
```

### 4. Review & Pay Claim (Owner / Governance)

```javascript
await pool.reviewClaim(claimId, true); // approve
await pool.payoutClaim(claimId);
```

---

## 🧪 Testing

- Comprehensive unit tests for all core functions
- Fuzzing for premium calculation edge cases
- Integration tests for full policy lifecycle
- Gas optimization tests

Run with:

```bash
npm test -- --grep "Policy Purchase"
```

---

## 🔐 Security Considerations

- **Audits**: This project is in active development. **Get it audited** before mainnet deployment.
- **Emergency Pause**: Owner can pause critical functions if needed.
- **Reentrancy Protection**: All external calls are guarded.
- **Access Control**: Critical functions restricted via `onlyOwner` (to be replaced with governance).
- **Reserve Management**: Mechanisms to maintain healthy pool ratios.

**Never deploy unaudited code with real funds.**

---

## 📈 Future Roadmap

### Phase 1 (MVP)
- [x] Core InsurancePool contract
- [x] Premium quoting & policy creation
- [x] Basic claim workflow

### Phase 2
- Policy NFTs (ERC-721)
- Multi-risk type support
- Automated claim triggers via oracles
- Dashboard frontend

### Phase 3
- Full DAO governance
- Capital efficiency (yield on reserves)
- Cross-chain coverage (via bridges)
- Actuarial model V2 with on-chain risk scoring

---

## 🤝 Contributing

We welcome contributions!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## ⚠️ Disclaimer

This is experimental DeFi software. Use at your own risk.  
The protocol is provided "as is" without any warranties.  
Smart contract insurance does **not** eliminate all risks — always do your own research (DYOR).

**Not financial advice.**

---

## 📬 Contact & Links

- **Repository**: [github.com/Ashfaque965/DeFi-Insurance-Protocol](https://github.com/Ashfaque965/DeFi-Insurance-Protocol)
- **Author**: Ashfaque Quraishi
- **Issues**: [Report a bug](https://github.com/Ashfaque965/DeFi-Insurance-Protocol/issues)

---

**Built with ❤️ for a safer DeFi ecosystem.**

---

*Last updated: June 2026*
```
