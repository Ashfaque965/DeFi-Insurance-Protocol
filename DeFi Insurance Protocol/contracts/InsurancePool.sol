// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InsurancePool {
    enum ClaimStatus {
        Pending,
        Approved,
        Denied,
        Paid
    }

    struct Policy {
        address holder;
        uint256 coverage;
        uint256 premium;
        uint64 start;
        uint64 end;
        bool active;
    }

    struct Claim {
        uint256 policyId;
        address claimant;
        uint256 amount;
        string evidenceUri;
        ClaimStatus status;
    }

    address public owner;
    uint256 public policyCount;
    uint256 public claimCount;
    uint256 public totalPremiums;
    uint256 public totalPayouts;
    uint256 public totalCoverageActive;
    uint256 public premiumRateBpsPerYear;

    mapping(uint256 => Policy) public policies;
    mapping(uint256 => Claim) public claims;

    event PolicyCreated(uint256 indexed policyId, address indexed holder, uint256 coverage, uint256 premium);
    event PolicyExpired(uint256 indexed policyId);
    event ClaimSubmitted(uint256 indexed claimId, uint256 indexed policyId, address indexed claimant, uint256 amount);
    event ClaimReviewed(uint256 indexed claimId, bool approved);
    event ClaimPaid(uint256 indexed claimId, address indexed claimant, uint256 amount);
    event PoolFunded(address indexed from, uint256 amount);
    event PremiumRateUpdated(uint256 newRateBpsPerYear);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(uint256 rateBpsPerYear) {
        owner = msg.sender;
        premiumRateBpsPerYear = rateBpsPerYear;
    }

    receive() external payable {
        emit PoolFunded(msg.sender, msg.value);
    }

    function fundPool() external payable {
        emit PoolFunded(msg.sender, msg.value);
    }

    function setPremiumRate(uint256 newRateBpsPerYear) external onlyOwner {
        premiumRateBpsPerYear = newRateBpsPerYear;
        emit PremiumRateUpdated(newRateBpsPerYear);
    }

    function quotePremium(uint256 coverage, uint64 duration) public view returns (uint256) {
        require(duration > 0, "duration=0");
        return (coverage * premiumRateBpsPerYear * duration) / (365 days) / 10000;
    }

    function createPolicy(uint256 coverage, uint64 duration) external payable returns (uint256 policyId) {
        require(coverage > 0, "coverage=0");
        uint256 premium = quotePremium(coverage, duration);
        require(msg.value == premium, "premium mismatch");

        policyId = ++policyCount;
        uint64 startTime = uint64(block.timestamp);
        uint64 endTime = startTime + duration;

        policies[policyId] = Policy({
            holder: msg.sender,
            coverage: coverage,
            premium: premium,
            start: startTime,
            end: endTime,
            active: true
        });

        totalPremiums += premium;
        totalCoverageActive += coverage;

        emit PolicyCreated(policyId, msg.sender, coverage, premium);
    }

    function expirePolicy(uint256 policyId) public {
        Policy storage policy = policies[policyId];
        require(policy.active, "not active");
        require(block.timestamp > policy.end, "not expired");

        policy.active = false;
        totalCoverageActive -= policy.coverage;

        emit PolicyExpired(policyId);
    }

    function submitClaim(uint256 policyId, uint256 amount, string calldata evidenceUri) external returns (uint256 claimId) {
        Policy storage policy = policies[policyId];
        require(policy.active, "inactive policy");
        require(block.timestamp <= policy.end, "policy expired");
        require(msg.sender == policy.holder, "not holder");
        require(amount > 0 && amount <= policy.coverage, "invalid amount");

        claimId = ++claimCount;
        claims[claimId] = Claim({
            policyId: policyId,
            claimant: msg.sender,
            amount: amount,
            evidenceUri: evidenceUri,
            status: ClaimStatus.Pending
        });

        emit ClaimSubmitted(claimId, policyId, msg.sender, amount);
    }

    function reviewClaim(uint256 claimId, bool approve) external onlyOwner {
        Claim storage claim = claims[claimId];
        require(claim.status == ClaimStatus.Pending, "not pending");

        claim.status = approve ? ClaimStatus.Approved : ClaimStatus.Denied;
        emit ClaimReviewed(claimId, approve);
    }

    function payoutClaim(uint256 claimId) external {
        Claim storage claim = claims[claimId];
        require(claim.status == ClaimStatus.Approved, "not approved");

        Policy storage policy = policies[claim.policyId];
        if (policy.active) {
            policy.active = false;
            totalCoverageActive -= policy.coverage;
        }

        claim.status = ClaimStatus.Paid;
        totalPayouts += claim.amount;

        (bool ok, ) = claim.claimant.call{value: claim.amount}("");
        require(ok, "payout failed");

        emit ClaimPaid(claimId, claim.claimant, claim.amount);
    }
}
