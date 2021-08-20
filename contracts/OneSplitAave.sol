// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "./interface/IAaveToken.sol";
import "./OneSplitBase.sol";


abstract contract OneSplitAaveView is OneSplitViewWrapBase {
    function getExpectedReturnWithGas(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256 parts,
        uint256 flags, // See constants in IOneSplit.sol
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
        return _aaveGetExpectedReturn(
            fromToken,
            destToken,
            amount,
            parts,
            flags,
            destTokenEthPriceTimesGasPrice
        );
    }

    function _aaveGetExpectedReturn(
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

        if (DisableDisableFlags.check(flags, flags, FLAG_DISABLE_ALL_WRAP_SOURCES) == DisableDisableFlags.check(flags, flags, FLAG_DISABLE_AAVE)) {
            ERC20 underlying = aaveRegistry.tokenByAToken(IAaveToken(address(fromToken)));
            if (underlying != ERC20(0)) {
                (returnAmount, estimateGasAmount, distribution) = _aaveGetExpectedReturn(
                    underlying,
                    destToken,
                    amount,
                    parts,
                    flags,
                    destTokenEthPriceTimesGasPrice
                );
                return (returnAmount, estimateGasAmount + 670_000, distribution);
            }

            underlying = aaveRegistry.tokenByAToken(IAaveToken(address(destToken)));
            if (underlying != ERC20(0)) {
                (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
                    fromToken,
                    underlying,
                    amount,
                    parts,
                    flags,
                    destTokenEthPriceTimesGasPrice
                );
                return (returnAmount, estimateGasAmount + 310_000, distribution);
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


abstract contract OneSplitAave is OneSplitBaseWrap {
    function _swap(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256[] memory distribution,
        uint256 flags
    ) override internal {
        _aaveSwap(
            fromToken,
            destToken,
            amount,
            distribution,
            flags
        );
    }

    function _aaveSwap(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256[] memory distribution,
        uint256 flags
    ) private {
        if (fromToken == destToken) {
            return;
        }

        if (DisableDisableFlags.check(flags, flags, FLAG_DISABLE_ALL_WRAP_SOURCES) == DisableDisableFlags.check(flags, flags, FLAG_DISABLE_AAVE)) {
            ERC20 underlying = aaveRegistry.tokenByAToken(IAaveToken(address(fromToken)));
            if (underlying != ERC20(0)) {
                IAaveToken(address(fromToken)).redeem(amount);

                return _aaveSwap(
                    underlying,
                    destToken,
                    amount,
                    distribution,
                    flags
                );
            }

            underlying = aaveRegistry.tokenByAToken(IAaveToken(address(destToken)));
            if (underlying != ERC20(0)) {
                super._swap(
                    fromToken,
                    underlying,
                    amount,
                    distribution,
                    flags
                );

                uint256 underlyingAmount = underlying.universalBalanceOf(address(this));

                underlying.universalApprove(aave.core(), underlyingAmount);
                aave.deposit.value(underlying.isETH() ? underlyingAmount : 0)(
                    underlying.isETH() ? ETH_ADDRESS : underlying,
                    underlyingAmount,
                    1101
                );
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
