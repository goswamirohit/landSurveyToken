
# 🏡 Land Registry Blockchain System

A smart contract-based land registry system built on Ethereum, enabling secure and transparent recording of land ownership, buying/selling transactions, and updates — powered by an ERC-20 token (`LandSurveyToken`).

## 🔗 Overview

This decentralized application (dApp) leverages blockchain technology to digitize land records and ensure verifiable ownership, offering a trustless, tamper-proof platform for real estate transactions.

## 📦 Features

- ✅ Admin-based land registration
- ✅ Owners can list land for sale
- ✅ Buyers purchase land using ERC-20 tokens
- ✅ Ownership and metadata updates are logged on-chain
- ✅ Fully transparent and auditable system via events
- ✅ Immutable history of ownership and changes

---

## 🔧 Smart Contracts

### 🔹 `LandSurveyToken.sol`
ERC-20 token used as a medium for buying and selling land within the registry system.

### 🔹 `LandRegistryWithToken.sol`
Handles:
- Land registration (admin only)
- Marking land for sale
- Token-based purchase and ownership transfer
- Metadata updates (location, area)

---

## 🚀 Getting Started

### 📚 Prerequisites
- [Node.js](https://nodejs.org/)
- [Hardhat](https://hardhat.org/) or [Remix IDE](https://remix.ethereum.org/)
- MetaMask wallet (for testing or deployment on testnets)

### 📁 Installation

```bash
git clone https://github.com/Rutmaniyar/landSurveyToken.git
cd land-registry-blockchain
npm install
```

---

## 🛠 Deployment Guide

### Using Remix

1. Open Remix IDE.
2. Upload both `.sol` files.
3. Compile using Solidity `^0.8.0`.
4. Deploy `LandSurveyToken.sol` first and copy its address.
5. Deploy `LandRegistryWithToken.sol` with the token address as a constructor parameter.

---

## 🔍 Sample Workflow

```solidity
// Admin registers land
registerLand("Sector 21A", 500, 0xOwnerAddress);

// Owner lists it for sale
markForSale(1, 1000); // 1000 tokens

// Buyer approves token transfer
LandSurveyToken.approve(RegistryAddress, 1000);

// Buyer purchases land
buyLand(1);

// Owner updates land metadata
updateLandDetails(1, "Sector 21B", 550);
```

---

## 📑 License

This project is licensed under the **MIT License**.

---

## 🤝 Contributing

Feel free to fork, raise issues, or open pull requests. All contributions are welcome.

---

## 👨‍💻 Authors & Contributors

This project and its original concept are a collaborative creation by:

- [**Rut Maniyar**](https://github.com/Rutmaniyar)
- [**Rohit Goswami**](https://github.com/goswamirohit)

Together, we aim to revolutionize digital land records through decentralized technology.
