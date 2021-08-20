// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "./interface/ICompound.sol";
import "./OneSplitBase.sol";


abstract contract OneSplitCompoundView is OneSplitViewWrapBase {
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
        return _compoundGetExpectedReturn(
            fromToken,
            destToken,
            amount,
            parts,
            flags,
            destTokenEthPriceTimesGasPrice
        );
    }

    function _compoundGetExpectedReturn(
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

        if (DisableDisableFlags.check(flags, flags, FLAG_DISABLE_ALL_WRAP_SOURCES) == DisableDisableFlags.check(flags, flags, FLAG_DISABLE_COMPOUND)) {
            ERC20 underlying = compoundRegistry.tokenByCToken(ICompoundToken(address(fromToken)));
            if (underlying != ERC20(0)) {
                uint256 compoundRate = ICompoundToken(address(fromToken)).exchangeRateStored();
                (returnAmount, estimateGasAmount, distribution) = _compoundGetExpectedReturn(
                    underlying,
                    destToken,
                    amount.mul(compoundRate).div(1e18),
                    parts,
                    flags,
                    destTokenEthPriceTimesGasPrice
                );
                return (returnAmount, estimateGasAmount + 295_000, distribution);
            }

            underlying = compoundRegistry.tokenByCToken(ICompoundToken(address(destToken)));
            if (underlying != ERC20(0)) {
                uint256 _destTokenEthPriceTimesGasPrice = destTokenEthPriceTimesGasPrice;
                uint256 compoundRate = ICompoundToken(address(destToken)).exchangeRateStored();
                (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
                    fromToken,
                    underlying,
                    amount,
                    parts,
                    flags,
                    _destTokenEthPriceTimesGasPrice.mul(compoundRate).div(1e18)
                );
                return (returnAmount.mul(1e18).div(compoundRate), estimateGasAmount + 430_000, distribution);
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


abstract contract OneSplitCompound is OneSplitBaseWrap {
    function _swap(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256[] memory distribution,
        uint256 flags
    ) override internal {
        _compoundSwap(
            fromToken,
            destToken,
            amount,
            distribution,
            flags
        );
    }

    function _compoundSwap(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256[] memory distribution,
        uint256 flags
    ) private {
        if (fromToken == destToken) {
            return;
        }

        if (DisableDisableFlags.check(flags, flags, FLAG_DISABLE_ALL_WRAP_SOURCES) == DisableDisableFlags.check(flags, flags, FLAG_DISABLE_COMPOUND)) {
            ERC20 underlying = compoundRegistry.tokenByCToken(ICompoundToken(address(fromToken)));
            if (underlying != ERC20(0)) {
                ICompoundToken(address(fromToken)).redeem(amount);
                uint256 underlyingAmount = underlying.universalBalanceOf(address(this));

                return _compoundSwap(
                    underlying,
                    destToken,
                    underlyingAmount,
                    distribution,
                    flags
                );
            }

            underlying = compoundRegistry.tokenByCToken(ICompoundToken(address(destToken)));
            if (underlying != ERC20(0)) {
                super._swap(
                    fromToken,
                    underlying,
                    amount,
                    distribution,
                    flags
                );

                uint256 underlyingAmount = underlying.universalBalanceOf(address(this));

                if (underlying.isETH()) {
                    cETH.mint.value(underlyingAmount)();
                } else {
                    underlying.universalApprove(address(destToken), underlyingAmount);
                    ICompoundToken(address(destToken)).mint(underlyingAmount);
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
