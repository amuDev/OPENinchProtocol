// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/IERC20/IERC20.sol";


interface IKyberStorage {
    function getReserveIdsPerTokenSrc(
        IERC20 token
    ) external view returns (bytes32[] memory);
}
