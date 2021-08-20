// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/IERC20/IERC20.sol";


interface ISmartTokenFormula {
    function calculateLiquidateReturn(
        uint256 supply,
        uint256 reserveBalance,
        uint32 totalRatio,
        uint256 amount
    ) external view returns (uint256);

    function calculatePurchaseReturn(
        uint256 supply,
        uint256 reserveBalance,
        uint32 totalRatio,
        uint256 amount
    ) external view returns (uint256);
}
