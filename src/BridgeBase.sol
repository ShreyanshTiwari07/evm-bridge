// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IBSPC is IERC20{
function mint(address _to,uint256 _amount) external;
function burn(address _to, uint256 _amount) external;
}
contract BridgeBase is Ownable{

    event Burn(address indexed user, uint256 amount);
    mapping(address=>uint256) private pendingBalance;
    address public tokenAddress;
constructor(address _tokenAddress)Ownable(msg.sender){
tokenAddress=_tokenAddress;
}

function burn(address _tokenAddress, uint256 _amount)public {
require(_tokenAddress==tokenAddress);
require(pendingBalance[msg.sender]>=_amount);
IBSPC(_tokenAddress).burn(msg.sender, _amount);
emit Burn(msg.sender, _amount);
}

function withdraw(address _tokenAddress, uint256 _amount) public {
    require(_tokenAddress==tokenAddress);
    require(pendingBalance[msg.sender]>=_amount);
    pendingBalance[msg.sender]-=_amount;
    IBSPC(_tokenAddress).mint(msg.sender, _amount);
}

function depositedOnTheOtherChain(address userAccount, uint256 _amount) public onlyOwner {
    pendingBalance[userAccount]+=_amount;
}
}