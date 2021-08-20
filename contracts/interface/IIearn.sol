// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IIearn is ERC20 {
    function token() external view returns(ERC20);

    function calcPoolValueInToken() external view returns(uint256);

    function deposit(uint256 _amount) external;

    function withdraw(uint256 _shares) external;
}
