// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "./IUniswapV2Exchange.sol";


interface IUniswapV2Factory {
    function getPair(ERC20 tokenA, ERC20 tokenB) external view returns (IUniswapV2Exchange pair);
}
