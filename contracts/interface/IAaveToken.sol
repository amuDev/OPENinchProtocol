// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/IERC20/IERC20.sol";


interface IAaveToken is IERC20 {
    function underlyingAssetAddress() external view returns (IERC20);

    function redeem(uint256 amount) external;
}


interface IAaveLendingPool {
    function core() external view returns (address);

    function deposit(IERC20 token, uint256 amount, uint16 refCode) external payable;
}
