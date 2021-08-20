// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/IERC20/IERC20.sol";


interface IBancorEtherToken is IERC20 {
    function deposit() external payable;

    function withdraw(uint256 amount) external;
}
