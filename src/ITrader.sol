// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { AggregatorV3Interface } from "./Interfaces/ChainLink/AggregatorV3Interface.sol";
//import { UniswapExchangeInterface } from "../Interfaces/UniSwap/UniswapV3ExchangeInterface.sol";
import { IERC20 } from "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "../node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { Ownable } from "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import { ISwapRouter } from "../node_modules/@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
//import { TimedLockedVault } from "../TimeLockedVault.sol";
import { ITimeLockedVault } from "./ITimeLockedVault.sol";

interface ITrader {
    
    function requestTrade(address _tokenIn, uint256 totalCollateralTokenIn, address _tokenOut, uint256 amountBorrowedTokenOut, uint256 assetPrice) external returns (uint256 amountOut);


    function getLeverageAndPrice(address _tokenIn, uint256 totalCollateralTokenIn, address _tokenOut, uint256 amountBorrowedTokenOut) external view returns (uint32 leveragedValue, uint8 decimals, int256 assetPrice);

    function getGainsOrLosses(address _tokenIn, address _tokenOut, uint256 amountBorrowedTokenOut, int256 debt) external view returns(int256 gainsOrLosses, int256 assetPrice);

    function haltIfDepeged(address _tokenIn, address _tokenOut) external view;

    function getVault(address token) external view returns(ITimeLockedVault);
}
