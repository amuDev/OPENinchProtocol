// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IBdai is ERC20 {
    function join(uint256) external;

    function exit(uint256) external;
}
