// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IBalancerPool {
    function getSwapFee()
        external view returns (uint256 balance);

    function getDenormalizedWeight(ERC20 token)
        external view returns (uint256 balance);

    function getBalance(ERC20 token)
        external view returns (uint256 balance);

    function swapExactAmountIn(
        ERC20 tokenIn,
        uint256 tokenAmountIn,
        ERC20 tokenOut,
        uint256 minAmountOut,
        uint256 maxPrice
    )
        external
        returns (uint256 tokenAmountOut, uint256 spotPriceAfter);
}


// 0xA961672E8Db773be387e775bc4937C678F3ddF9a
interface IBalancerHelper {
    function getReturns(
        IBalancerPool pool,
        ERC20 fromToken,
        ERC20 destToken,
        uint256[] calldata amounts
    )
        external
        view
        returns(uint256[] memory rets);
}
