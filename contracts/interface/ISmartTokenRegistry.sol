// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface ISmartTokenRegistry {
    function isSmartToken(ERC20 token) external view returns (bool);
}
