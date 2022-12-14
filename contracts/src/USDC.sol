// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;



import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
//Mock usdc for local testing.

contract USDC is ERC20{

constructor(uint256 initialSupply) ERC20("USDC", "USDC") {
        _mint(msg.sender, initialSupply);
    }

    function mint () public {
        _mint(msg.sender,10000);
    }


}