// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IDMMController {
    function getUnderlyingTokenForDmm(ERC20 token) external view returns(ERC20);
}


interface IDMM is ERC20 {
    function getCurrentExchangeRate() external view returns(uint256);
    function mint(uint256 underlyingAmount) external returns(uint256);
    function redeem(uint256 amount) external returns(uint256);
}
