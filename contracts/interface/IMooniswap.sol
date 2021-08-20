// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IMooniswapRegistry {
    function pools(ERC20 token1, ERC20 token2) external view returns(IMooniswap);
    function isPool(address addr) external view returns(bool);
}


interface IMooniswap {
    function fee() external view returns (uint256);

    function tokens(uint256 i) external view returns (ERC20);

    function deposit(uint256[] calldata amounts, uint256[] calldata minAmounts) external payable returns(uint256 fairSupply);

    function withdraw(uint256 amount, uint256[] calldata minReturns) external;

    function getBalanceForAddition(ERC20 token) external view returns(uint256);

    function getBalanceForRemoval(ERC20 token) external view returns(uint256);

    function getReturn(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount
    )
        external
        view
        returns(uint256 returnAmount);

    function swap(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256 minReturn,
        address referral
    )
        external
        payable
        returns(uint256 returnAmount);
}
