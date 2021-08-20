// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IBancorFinder {
    function buildBancorPath(
        ERC20 fromToken,
        ERC20 destToken
    )
        external
        view
        returns(address[] memory path);
}
