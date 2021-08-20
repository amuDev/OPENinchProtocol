// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/IERC20/IERC20.sol";


interface ISmartTokenRegistry {
    function isSmartToken(IERC20 token) external view returns (bool);
}
