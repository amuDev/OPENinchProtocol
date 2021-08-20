// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ICompound.sol";


interface ICompoundRegistry {
    function tokenByCToken(ICompoundToken cToken) external view returns(ERC20);
    function cTokenByToken(ERC20 token) external view returns(ICompoundToken);
}
