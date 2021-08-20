// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface ISmartTokenConverter {
    function getReserveRatio(ERC20 token) external view returns (uint32);

    function connectorTokenCount() external view returns (uint256);

    function connectorTokens(uint256 i) external view returns (ERC20);
}
