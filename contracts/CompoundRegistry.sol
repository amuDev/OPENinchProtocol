// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interface/ICompoundRegistry.sol";
import "./UniversalERC20.sol";


contract CompoundRegistry is Ownable, ICompoundRegistry {
    using UniversalERC20 for ERC20;

    ICompoundToken internal constant cETH = ICompoundToken(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5);
    ERC20 internal constant ETH = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    mapping(address => address) private _tokenByCToken;
    mapping(address => address) private _cTokenByToken;

    function tokenByCToken(ICompoundToken cToken) external view override returns(ERC20) {
        if (cToken == cETH) {
            return ETH;
        }
        return ERC20(_tokenByCToken[address(cToken)]);
    }

    function cTokenByToken(ERC20 token) external view override returns(ICompoundToken) {
        if (token.isETH()) {
            return cETH;
        }
        return ICompoundToken(_cTokenByToken[address(token)]);
    }

    function addCToken(ICompoundToken cToken) public onlyOwner {
        ERC20 token = ERC20(cToken.underlying());
        _tokenByCToken[address(cToken)] = address(token);
        _cTokenByToken[address(token)] = address(cToken);
    }

    function addCTokens(ICompoundToken[] calldata cTokens) external onlyOwner {
        for (uint i = 0; i < cTokens.length; i++) {
            addCToken(cTokens[i]);
        }
    }
}
