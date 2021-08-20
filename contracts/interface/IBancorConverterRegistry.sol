// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IBancorConverterRegistry {

    function getConvertibleTokenSmartTokenCount(ERC20 convertibleToken)
        external view returns(uint256);

    function getConvertibleTokenSmartTokens(ERC20 convertibleToken)
        external view returns(address[] memory);

    function getConvertibleTokenSmartToken(ERC20 convertibleToken, uint256 index)
        external view returns(address);

    function isConvertibleTokenSmartToken(ERC20 convertibleToken, address value)
        external view returns(bool);
}
