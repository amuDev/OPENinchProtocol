// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IKyberNetworkContract {
    function searchBestRate(ERC20 src, ERC20 dest, uint256 srcAmount, bool usePermissionless)
        external
        view
        returns (address reserve, uint256 rate);
}
