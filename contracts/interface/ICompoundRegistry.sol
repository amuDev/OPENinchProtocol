// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/IERC20/IERC20.sol";
import "./ICompound.sol";


interface ICompoundRegistry {
    function tokenByCToken(ICompoundToken cToken) external view returns(IERC20);
    function cTokenByToken(IERC20 token) external view returns(ICompoundToken);
}
