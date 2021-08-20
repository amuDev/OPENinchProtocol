// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IDForceSwap {
    function getAmountByInput(ERC20 input, ERC20 output, uint256 amount) external view returns(uint256);
    function swap(ERC20 input, ERC20 output, uint256 amount) external;
}
