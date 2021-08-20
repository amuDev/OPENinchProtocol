// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "./interface/IChai.sol";
import "./OneSplitBase.sol";


abstract contract OneSplitChaiView is OneSplitViewWrapBase {
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

        if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_CHAI)) {
            if (fromToken == ERC20(chai)) {
                (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
                    dai,
                    destToken,
                    chai.chaiToDai(amount),
                    parts,
                    flags,
                    destTokenEthPriceTimesGasPrice
                );
                return (returnAmount, estimateGasAmount + 197_000, distribution);
            }

            if (destToken == ERC20(chai)) {
                uint256 price = chai.chaiPrice();
                (returnAmount, estimateGasAmount, distribution) = super.getExpectedReturnWithGas(
                    fromToken,
                    dai,
                    amount,
                    parts,
                    flags,
                    destTokenEthPriceTimesGasPrice.mul(1e18).div(price)
                );
                return (returnAmount.mul(price).div(1e18), estimateGasAmount + 168_000, distribution);
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


abstract contract OneSplitChai is OneSplitBaseWrap {
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

        if (flags.check(FLAG_DISABLE_ALL_WRAP_SOURCES) == flags.check(FLAG_DISABLE_CHAI)) {
            if (fromToken == ERC20(chai)) {
                chai.exit(address(this), amount);

                return super._swap(
                    dai,
                    destToken,
                    dai.balanceOf(address(this)),
                    distribution,
                    flags
                );
            }

            if (destToken == ERC20(chai)) {
                super._swap(
                    fromToken,
                    dai,
                    amount,
                    distribution,
                    flags
                );

                uint256 daiBalance = dai.balanceOf(address(this));
                dai.universalApprove(address(chai), daiBalance);
                chai.join(address(this), daiBalance);
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
