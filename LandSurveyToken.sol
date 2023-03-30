// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract LandSurveyToken is IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 private _totalSupply;
    uint256 private tokenPrice;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    address private _owner;

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply, uint256 _tokenPrice) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        _totalSupply = _initialSupply * 10 ** uint256(decimals);
        _balances[msg.sender] = _totalSupply;
        _owner = msg.sender;
        tokenPrice = _tokenPrice;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[msg.sender] >= amount, "ERC20: transfer amount exceeds balance");
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
        require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        _allowances[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function buyTokens(uint256 tokenAmount) public payable {
        require(tokenAmount > 0, "Token amount must be greater than 0");
        require(_balances[_owner] >= tokenAmount, "Not enough tokens available for sale");
        uint256 ethAmount = tokenAmount * tokenPrice; // Calculate ETH amount based on the current token/ETH exchange rate
        require(msg.sender.balance >= ethAmount, "Insufficient ETH balance to purchase tokens");
        // require(msg.value >= ethAmount, "Insufficient ETH sent to purchase tokens");
        _balances[_owner] -= tokenAmount;
        _balances[msg.sender] += tokenAmount;
        emit Transfer(_owner, msg.sender, tokenAmount);
        if (msg.value > ethAmount) {
            payable(msg.sender).transfer(msg.sender.balance - ethAmount); // Refund any excess ETH
        }
    }
}
