// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "./IKyberNetworkContract.sol";


interface IKyberNetworkProxy {
    function getExpectedRateAfterFee(
        ERC20 src,
        ERC20 dest,
        uint256 srcQty,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external view returns (uint256 expectedRate);

    function tradeWithHintAndFee(
        ERC20 src,
        uint256 srcAmount,
        ERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable platformWallet,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external payable returns (uint256 destAmount);

    function kyberNetworkContract() external view returns (IKyberNetworkContract);

    // TODO: Limit usage by tx.gasPrice
    // function maxGasPrice() external view returns (uint256);

    // TODO: Limit usage by user cap
    // function getUserCapInWei(address user) external view returns (uint256);
    // function getUserCapInTokenWei(address user, ERC20 token) external view returns (uint256);
}
