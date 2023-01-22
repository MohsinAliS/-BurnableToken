// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

error totalSupplyExceed();

contract BrnToken is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("TokenBurn", "TBT") {}

    uint256 public supply = 100 ether;
    uint256 public burnfee = 200;

    function setburnAmount(uint256 amount) public {
        burnfee = amount;
    }

    function burnPersontage(uint256 amount) public view returns (uint256) {
        return ((amount / 10000) * burnfee);
    }

    function mint(uint256 amount) public {
        if (totalSupply() + amount > supply) {
            revert totalSupplyExceed();
        }
        _mint(msg.sender, amount);
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        uint256 temp = burnPersontage(amount);
        uint256 sendamount = amount - temp;
        _burn(msg.sender, temp);
        address owner = _msgSender();
        _transfer(owner, to, sendamount);
        return true;
    }
}
