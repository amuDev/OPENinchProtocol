// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/IERC20/IERC20.sol";
import "./ISmartTokenConverter.sol";


interface ISmartToken {
    function owner() external view returns (ISmartTokenConverter);
}
