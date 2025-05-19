// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

/// @title Land Registry System Using ERC-20 Token
/// @notice Manages land registration, sales, and transfers using LandSurveyToken for payments
contract LandRegistryWithToken {

    address public admin;
    IERC20 public paymentToken;

    constructor(address tokenAddress) {
        admin = msg.sender;
        paymentToken = IERC20(tokenAddress);
    }

    struct Land {
        uint id;
        string location;
        uint area; // square meters
        address owner;
        bool forSale;
        uint price; // in tokens
    }

    uint public landCounter = 0;
    mapping(uint => Land) public lands;

    // Events
    event LandRegistered(uint id, string location, uint area, address indexed owner);
    event LandForSale(uint id, uint price);
    event LandSold(uint id, address indexed oldOwner, address indexed newOwner, uint price);
    event LandUpdated(uint id, string newLocation, uint newArea);

    // Modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyOwner(uint landId) {
        require(lands[landId].owner == msg.sender, "Only land owner can perform this action");
        _;
    }

    /// @notice Register new land
    function registerLand(string memory location, uint area, address owner) public onlyAdmin {
        landCounter++;
        lands[landCounter] = Land(landCounter, location, area, owner, false, 0);
        emit LandRegistered(landCounter, location, area, owner);
    }

    /// @notice Mark land for sale with price in tokens
    function markForSale(uint landId, uint price) public onlyOwner(landId) {
        Land storage land = lands[landId];
        land.forSale = true;
        land.price = price;
        emit LandForSale(landId, price);
    }

    /// @notice Buy land using LandSurveyToken
    function buyLand(uint landId) public {
        Land storage land = lands[landId];
        require(land.forSale, "Land not for sale");

        address seller = land.owner;
        require(seller != msg.sender, "Cannot buy your own land");

        uint price = land.price;

        // Transfer tokens from buyer to seller
        bool success = paymentToken.transferFrom(msg.sender, seller, price);
        require(success, "Token transfer failed");

        // Update ownership
        land.owner = msg.sender;
        land.forSale = false;
        land.price = 0;

        emit LandSold(landId, seller, msg.sender, price);
    }

    /// @notice Update land metadata
    function updateLandDetails(uint landId, string memory newLocation, uint newArea) public onlyOwner(landId) {
        Land storage land = lands[landId];
        land.location = newLocation;
        land.area = newArea;

        emit LandUpdated(landId, newLocation, newArea);
    }

    /// @notice Get land info
    function getLand(uint landId) public view returns (Land memory) {
        return lands[landId];
    }
}
