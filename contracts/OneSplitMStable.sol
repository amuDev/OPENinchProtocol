// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "./interface/IChai.sol";
import "./OneSplitBase.sol";


abstract contract OneSplitMStableView is OneSplitViewWrapBase {
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
        if (fromToken == destToken) {
            return (amount, 0, new uint256[](DEXES_COUNT));
        }

        if (DisableDisableFlags.check(flags, flags, FLAG_DISABLE_ALL_WRAP_SOURCES) == DisableDisableFlags.check(flags, flags, FLAG_DISABLE_MSTABLE_MUSD)) {
            if (fromToken == ERC20(musd)) {
                {
                    (bool valid1,, uint256 res1,) = musd_helper.getRedeemValidity(musd, amount, destToken);
                    if (valid1) {
                        return (res1, 300_000, new uint256[](DEXES_COUNT));
                    }
                }

                (bool valid,, address token) = musd_helper.suggestRedeemAsset(musd);
                if (valid) {
                    (,, returnAmount,) = musd_helper.getRedeemValidity(musd, amount, ERC20(token));
                    if (ERC20(token) != destToken) {
                        (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
                            ERC20(token),
                            destToken,
                            returnAmount,
                            parts,
                            flags,
                            destTokenEthPriceTimesGasPrice
                        );
                    } else {
                        distribution = new uint256[](DEXES_COUNT);
                    }

                    return (returnAmount, estimateGasAmount + 300_000, distribution);
                }
            }

            if (destToken == ERC20(musd)) {
                if (fromToken == usdc || fromToken == dai || fromToken == usdt || fromToken == tusd) {
                    (,, returnAmount) = musd.getSwapOutput(fromToken, destToken, amount);
                    return (returnAmount, 300_000, new uint256[](DEXES_COUNT));
                }
                else {
                    ERC20 _destToken = destToken;
                    (bool valid,, address token) = musd_helper.suggestMintAsset(_destToken);
                    if (valid) {
                        if (ERC20(token) != fromToken) {
                            (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
                                fromToken,
                                ERC20(token),
                                amount,
                                parts,
                                flags,
                                _scaleDestTokenEthPriceTimesGasPrice(
                                    _destToken,
                                    ERC20(token),
                                    destTokenEthPriceTimesGasPrice
                                )
                            );
                        } else {
                            returnAmount = amount;
                        }
                        (,, returnAmount) = musd.getSwapOutput(ERC20(token), _destToken, returnAmount);
                        return (returnAmount, estimateGasAmount + 300_000, distribution);
                    }
                }
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


abstract contract OneSplitMStable is OneSplitBaseWrap {
    function _swap(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256[] memory distribution,
        uint256 flags
    ) override internal {
        if (fromToken == destToken) {
            return;
        }

        if (DisableDisableFlags.check(flags, flags, FLAG_DISABLE_ALL_WRAP_SOURCES) == DisableDisableFlags.check(flags, flags, FLAG_DISABLE_MSTABLE_MUSD)) {
            if (fromToken == ERC20(musd)) {
                if (destToken == usdc || destToken == dai || destToken == usdt || destToken == tusd) {
                    (,,, uint256 result) = musd_helper.getRedeemValidity(fromToken, amount, destToken);
                    musd.redeem(
                        destToken,
                        result
                    );
                }
                else {
                    (,,, uint256 result) = musd_helper.getRedeemValidity(fromToken, amount, dai);
                    musd.redeem(
                        dai,
                        result
                    );
                    super._swap(
                        dai,
                        destToken,
                        dai.balanceOf(address(this)),
                        distribution,
                        flags
                    );
                }
                return;
            }

            if (destToken == ERC20(musd)) {
                if (fromToken == usdc || fromToken == dai || fromToken == usdt || fromToken == tusd) {
                    fromToken.universalApprove(address(musd), amount);
                    musd.swap(
                        fromToken,
                        destToken,
                        amount,
                        address(this)
                    );
                }
                else {
                    super._swap(
                        fromToken,
                        dai,
                        amount,
                        distribution,
                        flags
                    );
                    musd.swap(
                        dai,
                        destToken,
                        dai.balanceOf(address(this)),
                        address(this)
                    );
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
