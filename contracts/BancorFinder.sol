// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interface/IBancorContractRegistry.sol";
import "./interface/IBancorConverterRegistry.sol";
import "./UniversalERC20.sol";


contract BancorFinder {
    using UniversalERC20 for ERC20;

    ERC20 constant internal ETH_ADDRESS = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
    ERC20 constant internal bnt = ERC20(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);
    IBancorContractRegistry constant internal bancorContractRegistry = IBancorContractRegistry(0x52Ae12ABe5D8BD778BD5397F99cA900624CfADD4);

    function buildBancorPath(
        ERC20 fromToken,
        ERC20 destToken
    )
        public
        view
        returns(address[] memory path)
    {
        if (fromToken == destToken) {
            return new address[](0);
        }

        if (UniversalERC20.isETH(fromToken)) {
            fromToken = ETH_ADDRESS;
        }
        if (UniversalERC20.isETH(destToken)) {
            destToken = ETH_ADDRESS;
        }

        if (fromToken == bnt || destToken == bnt) {
            path = new address[](3);
        } else {
            path = new address[](5);
        }

        address fromConverter;
        address toConverter;

        IBancorConverterRegistry bancorConverterRegistry = IBancorConverterRegistry(
            bancorContractRegistry.addressOf("BancorConverterRegistry")
        );

        if (fromToken != bnt) {
            (bool success, bytes memory data) = address(bancorConverterRegistry).staticcall{gas:100000}(abi.encodeWithSelector(
                bancorConverterRegistry.getConvertibleTokenSmartToken.selector,
                UniversalERC20.isETH(fromToken) ? ETH_ADDRESS : fromToken,
                0
            ));
            if (!success) {
                return new address[](0);
            }

            fromConverter = abi.decode(data, (address));
            if (fromConverter == address(0)) {
                return new address[](0);
            }
        }

        if (destToken != bnt) {
            (bool success, bytes memory data) = address(bancorConverterRegistry).staticcall{gas:100000}(abi.encodeWithSelector(
                bancorConverterRegistry.getConvertibleTokenSmartToken.selector,
                UniversalERC20.isETH(destToken) ? ETH_ADDRESS : destToken,
                0
            ));
            if (!success) {
                return new address[](0);
            }

            toConverter = abi.decode(data, (address));
            if (toConverter == address(0)) {
                return new address[](0);
            }
        }

        if (destToken == bnt) {
            path[0] = address(fromToken);
            path[1] = fromConverter;
            path[2] = address(bnt);
            return path;
        }

        if (fromToken == bnt) {
            path[0] = address(bnt);
            path[1] = toConverter;
            path[2] = address(destToken);
            return path;
        }

        path[0] = address(fromToken);
        path[1] = fromConverter;
        path[2] = address(bnt);
        path[3] = toConverter;
        path[4] = address(destToken);
        return path;
    }
}
