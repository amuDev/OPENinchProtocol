// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IBancorNetworkPathFinder {
    function generatePath(ERC20 sourceToken, ERC20 targetToken)
        external
        view
        returns (address[] memory);
}
