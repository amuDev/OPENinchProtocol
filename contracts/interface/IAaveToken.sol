// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IAaveToken is ERC20 {
    function underlyingAssetAddress() external view returns (ERC20);

    function redeem(uint256 amount) external;
}


interface IAaveLendingPool {
    function core() external view returns (address);

    function deposit(ERC20 token, uint256 amount, uint16 refCode) external payable;
}
