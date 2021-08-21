// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


interface IKyberNetworkContract {
    function searchBestRate(IERC20 src, IERC20 dest, uint256 srcAmount, bool usePermissionless)
        external
        view
        returns (address reserve, uint256 rate);
}
