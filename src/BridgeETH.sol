// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeETH is Ownable{
    event Deposit(address indexed depositor, uint amount);
    address public tokenAddress;
    mapping(address=> uint256) private pendingBalance;
    constructor(address _tokenAddress)Ownable(msg.sender){
        tokenAddress=_tokenAddress; 
    }

    function deposit (address _tokenAddress,uint256 _amount) public {
        require(_tokenAddress==tokenAddress);
        require(IERC20(_tokenAddress).allowance(msg.sender,address(this))>=_amount);
        require(IERC20(_tokenAddress).transferFrom(msg.sender,address(this),_amount));
        pendingBalance[msg.sender]+=_amount;
       emit Deposit(msg.sender,_amount);
    }

    function withdraw(address _tokenAddress, uint256 _amount) public {
      require(_tokenAddress==tokenAddress);
      require(pendingBalance[msg.sender]>=_amount);
      require(address(this).balance>=_amount);
      pendingBalance[msg.sender]-=_amount;
      IERC20(_tokenAddress).transfer(msg.sender, _amount);
    }

    function burnedOnOtherChain(address _userAccount, uint256 _amount) public onlyOwner {
      pendingBalance[_userAccount]+=_amount;
    }

}