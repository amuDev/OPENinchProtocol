// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


interface IBancorNetworkPathFinder {
    function generatePath(IERC20 sourceToken, IERC20 targetToken)
        external
        view
        returns (address[] memory);
}
