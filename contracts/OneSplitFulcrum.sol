// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "./interface/IFulcrum.sol";
import "./OneSplitBase.sol";


contract OneSplitFulcrumBase {
    using UniversalERC20 for ERC20;

    function _isFulcrumToken(ERC20 token) internal view returns(ERC20) {
        if (token.isETH()) {
            return ERC20(-1);
        }

        (bool success, bytes memory data) = address(token).staticcall.gas(5000)(abi.encodeWithSignature(
            "name()"
        ));
        if (!success) {
            return ERC20(-1);
        }

        bool foundBZX = false;
        for (uint i = 0; i + 6 < data.length; i++) {
            if (data[i + 0] == "F" &&
                data[i + 1] == "u" &&
                data[i + 2] == "l" &&
                data[i + 3] == "c" &&
                data[i + 4] == "r" &&
                data[i + 5] == "u" &&
                data[i + 6] == "m")
            {
                foundBZX = true;
                break;
            }
        }
        if (!foundBZX) {
            return ERC20(-1);
        }

        (success, data) = address(token).staticcall.gas(5000)(abi.encodeWithSelector(
            IFulcrumToken(address(token)).loanTokenAddress.selector
        ));
        if (!success) {
            return ERC20(-1);
        }

        return abi.decode(data, (ERC20));
    }
}


abstract contract OneSplitFulcrumView is OneSplitViewWrapBase, OneSplitFulcrumBase {
    function getExpectedReturnWithGas(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256 parts,
        uint256 flags,
        uint256 destTokenEthPriceTimesGasPrice
    ) override
        public
        view
        returns(
            uint256 returnAmount,
            uint256 estimateGasAmount,
            uint256[] memory distribution
        )
    {
        return _fulcrumGetExpectedReturn(
            fromToken,
            destToken,
            amount,
            parts,
            flags,
            destTokenEthPriceTimesGasPrice
        );
    }

    function _fulcrumGetExpectedReturn(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256 parts,
        uint256 flags,
        uint256 destTokenEthPriceTimesGasPrice
    )
        private
        view
        returns(
            uint256 returnAmount,
            uint256 estimateGasAmount,
            uint256[] memory distribution
        )
    {
        if (fromToken == destToken) {
            return (amount, 0, new uint256[](DEXES_COUNT));
        }

        if (DisableDisableFlags.check(flags, flags, FLAG_DISABLE_ALL_WRAP_SOURCES) == DisableDisableFlags.check(flags, flags, FLAG_DISABLE_FULCRUM)) {
            ERC20 underlying = _isFulcrumToken(fromToken);
            if (underlying != ERC20(-1)) {
                uint256 fulcrumRate = IFulcrumToken(address(fromToken)).tokenPrice();
                (returnAmount, estimateGasAmount, distribution) = _fulcrumGetExpectedReturn(
                    underlying,
                    destToken,
                    amount.mul(fulcrumRate).div(1e18),
                    parts,
                    flags,
                    destTokenEthPriceTimesGasPrice
                );
                return (returnAmount, estimateGasAmount + 381_000, distribution);
            }

            underlying = _isFulcrumToken(destToken);
            if (underlying != ERC20(-1)) {
                uint256 _destTokenEthPriceTimesGasPrice = destTokenEthPriceTimesGasPrice;
                uint256 fulcrumRate = IFulcrumToken(address(destToken)).tokenPrice();
                (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
                    fromToken,
                    underlying,
                    amount,
                    parts,
                    flags,
                    _destTokenEthPriceTimesGasPrice.mul(fulcrumRate).div(1e18)
                );
                return (returnAmount.mul(1e18).div(fulcrumRate), estimateGasAmount + 354_000, distribution);
            }
        }

        return super.getExpectedReturnWithGas(
            fromToken,
            destToken,
            amount,
            parts,
            flags,
            destTokenEthPriceTimesGasPrice
        );
    }
}


abstract contract OneSplitFulcrum is OneSplitBaseWrap, OneSplitFulcrumBase {
    function _swap(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256[] memory distribution,
        uint256 flags
    ) override internal {
        _fulcrumSwap(
            fromToken,
            destToken,
            amount,
            distribution,
            flags
        );
    }

    function _fulcrumSwap(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256[] memory distribution,
        uint256 flags
    ) private {
        if (fromToken == destToken) {
            return;
        }

        if (DisableDisableFlags.check(flags, flags, FLAG_DISABLE_ALL_WRAP_SOURCES) == DisableDisableFlags.check(flags, flags, FLAG_DISABLE_FULCRUM)) {
            ERC20 underlying = _isFulcrumToken(fromToken);
            if (underlying != ERC20(-1)) {
                if (underlying.isETH()) {
                    IFulcrumToken(address(fromToken)).burnToEther(address(this), amount);
                } else {
                    IFulcrumToken(address(fromToken)).burn(address(this), amount);
                }

                uint256 underlyingAmount = underlying.universalBalanceOf(address(this));

                return super._swap(
                    underlying,
                    destToken,
                    underlyingAmount,
                    distribution,
                    flags
                );
            }

            underlying = _isFulcrumToken(destToken);
            if (underlying != ERC20(-1)) {
                super._swap(
                    fromToken,
                    underlying,
                    amount,
                    distribution,
                    flags
                );

                uint256 underlyingAmount = underlying.universalBalanceOf(address(this));

                if (underlying.isETH()) {
                    IFulcrumToken(address(destToken)).mintWithEther.value(underlyingAmount)(address(this));
                } else {
                    underlying.universalApprove(address(destToken), underlyingAmount);
                    IFulcrumToken(address(destToken)).mint(address(this), underlyingAmount);
                }
                return;
            }
        }

        return super._swap(
            fromToken,
            destToken,
            amount,
            distribution,
            flags
        );
    }
}
