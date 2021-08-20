// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "./IUniswapExchange.sol";


interface IUniswapFactory {
    function getExchange(ERC20 token) external view returns (IUniswapExchange exchange);
}
