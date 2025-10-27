# 💰 Savings Pool Smart Contract

## Overview
The **Savings Pool** smart contract allows users to create personalized savings plans using an ERC20 token. Users can deposit tokens toward their savings goals, and optionally withdraw early (with a small fee) or once the goal is met (fee-free).

This project includes:
1. **`savingsPool.sol`** – The main contract for creating and managing savings plans.  
2. **`anthonyToken.sol`** – A sample ERC20 token implementation for testing the savings pool.

---

## 🧩 Contracts

### 1. `anthonyToken.sol`
A simple ERC20 token implementation using OpenZeppelin libraries.

**Key Features:**
- Token Name: `anthonyToken`
- Symbol: `ATN`
- Initial Supply: `50 * 10^18` (minted to deployer)
- Fully ERC20 compliant

```solidity
contract anthonyToken is ERC20 {
    constructor() ERC20("anthonyToken", "ATN") {
        _mint(msg.sender, 50 * 10 ** decimals());
    }
}
```

---

### 2. `savingsPool.sol`
A smart contract that lets users set savings goals, deposit ERC20 tokens, and withdraw funds (with or without an early-withdrawal fee).

**Core Functionalities:**

| Function | Description |
|-----------|--------------|
| `createPlan(uint256 _goalAmount)` | Create a new savings plan with a specific goal amount. |
| `deposit(uint256 _planId, uint256 _amount)` | Deposit tokens into a chosen savings plan (requires token approval first). |
| `withdraw(uint256 _planId)` | Withdraw funds from a savings plan. If withdrawn before reaching the goal, a fee applies. |
| `updateFeePercent(uint256 _newFee)` | Admin-only function to update the early withdrawal fee percentage. |

**Key Variables:**
- `feePercent`: Default 5% fee on early withdrawals.
- `userPlans`: Mapping of each user’s individual savings plans.
- `token`: ERC20 token used for savings.
- `admin`: Deployer and owner of the contract.

---

## ⚙️ Deployment

1. **Deploy `anthonyToken.sol`**
   - Copy and deploy the token contract.
   - Take note of the deployed token address.

2. **Deploy `savingsPool.sol`**
   - Pass the token contract address to the constructor:
     ```solidity
     new savingsPool(<token_address>)
     ```

---

## 🚀 Usage

### 1. Approve Spending
Before depositing, users must approve the pool contract to transfer tokens:
```solidity
token.approve(<savingsPool_address>, <amount>);
```

### 2. Create a Savings Plan
```solidity
savingsPool.createPlan(100 * 10**18); // Example goal: 100 ATN
```

### 3. Deposit Tokens
```solidity
savingsPool.deposit(1, 10 * 10**18); // Deposit 10 ATN into plan #1
```

### 4. Withdraw Funds
```solidity
savingsPool.withdraw(1); // Withdraw from plan #1
```

If withdrawn early, a 5% fee applies. Once the goal is reached, users can withdraw without fees.

---

## 🔒 Admin Controls
The contract owner (`admin`) can:
- Update the withdrawal fee using `updateFeePercent(uint256 _newFee)`.

---

## 🧠 Notes
- Built using **Solidity 0.8.20**
- Depends on **OpenZeppelin Contracts**
- Licensed under **MIT**

---

## 📜 License
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
