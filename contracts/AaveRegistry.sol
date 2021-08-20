// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interface/IAaveRegistry.sol";
import "./UniversalERC20.sol";


contract AaveRegistry is Ownable, IAaveRegistry {
    using UniversalERC20 for ERC20;

    IAaveToken internal constant aETH = IAaveToken(0x3a3A65aAb0dd2A17E3F1947bA16138cd37d08c04);
    ERC20 internal constant ETH = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    mapping(address => address) private _tokenByAToken;
    mapping(address => address) private _aTokenByToken;

    function tokenByAToken(IAaveToken aToken) external view override returns(ERC20) {
        if (aToken == aETH) {
            return ETH;
        }
        return ERC20(_tokenByAToken[address(aToken)]);
    }

    function aTokenByToken(ERC20 token) external view override returns(IAaveToken) {
        if (UniversalERC20.isETH(token)) {
            return aETH;
        }
        return IAaveToken(_aTokenByToken[address(token)]);
    }

    function addAToken(IAaveToken aToken) public onlyOwner {
        ERC20 token = ERC20(aToken.underlyingAssetAddress());
        _tokenByAToken[address(aToken)] = address(token);
        _aTokenByToken[address(token)] = address(aToken);
    }

    function addATokens(IAaveToken[] calldata cTokens) external onlyOwner {
        for (uint i = 0; i < cTokens.length; i++) {
            addAToken(cTokens[i]);
        }
    }
}
