// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IAaveToken.sol";

interface IAaveRegistry {
    function tokenByAToken(IAaveToken aToken) external view returns(ERC20);
    function aTokenByToken(ERC20 token) external view returns(IAaveToken);
}
