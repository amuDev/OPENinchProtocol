// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IOasisExchange {
    function getBuyAmount(ERC20 buyGem, ERC20 payGem, uint256 payAmt)
        external
        view
        returns (uint256 fillAmt);

    function sellAllAmount(ERC20 payGem, uint256 payAmt, ERC20 buyGem, uint256 minFillAmount)
        external
        returns (uint256 fillAmt);
}
