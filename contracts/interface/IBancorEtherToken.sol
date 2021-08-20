// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IBancorEtherToken is ERC20 {
    function deposit() external payable;

    function withdraw(uint256 amount) external;
}
