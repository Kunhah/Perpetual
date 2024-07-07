// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { AggregatorV3Interface } from "../Interfaces/ChainLink/AggregatorV3Interface.sol";
//import { UniswapExchangeInterface } from "../Interfaces/UniSwap/UniswapV3ExchangeInterface.sol";
import { IERC20 } from "../../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "../../node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { Ownable } from "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import { ISwapRouter } from "../../node_modules/@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
//import { TimedLockedVault } from "../TimeLockedVault.sol";
import { TimeLockedVault } from "../TimeLockedVault.sol";
//import { Perpetual } from "../Perpetual.sol";
import { PolygonPureFunctions } from "./PolygonPureFunctions.sol";

contract TraderPolygon is Ownable, PolygonPureFunctions {
    using SafeERC20 for IERC20;

    error TraderPolygon_SenderIsNotPerpetual(address sender);

    error TraderPolygon_InvalidPrice(uint80 roundId, int256 priceUSD, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

    error TraderPolygon_USDCDepeged();

    error TraderPolygon_wBTCDepeged();

    uint24 constant POOL_FEE = 3000;
    uint256 constant GRACE_PERIOD = 3600;
    uint256 constant LEVERAGE_PRECISION = 1000000;
    uint32 constant LEVERAGE_FLOOR = 10;

    TimeLockedVault immutable i_vaultwBTC;
    TimeLockedVault immutable i_vaultwETH;
    TimeLockedVault immutable i_vaultUSDC;
    TimeLockedVault immutable i_vaultSHIB;
    TimeLockedVault immutable i_vaultAPE;
    TimeLockedVault immutable i_vaultPAXG;
    TimeLockedVault immutable i_vault1INCH;
    TimeLockedVault immutable i_vaultAAVE;
    //TimeLockedVault immutable i_vaultARB; NOT FOUND
    TimeLockedVault immutable i_vaultAVAX;
    TimeLockedVault immutable i_vaultCRV;
    TimeLockedVault immutable i_vaultCOMP;
    TimeLockedVault immutable i_vaultMATIC;
    //TimeLockedVault immutable i_vaultSOL; NOT FOUND
    TimeLockedVault immutable i_vaultUNI;
    TimeLockedVault immutable i_vaultSUSHI;

    address immutable perpetual;

    address public constant routerAddress = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    ISwapRouter public immutable i_swapRouter = ISwapRouter(routerAddress);

    constructor (address _perpetual, address _owner) Ownable(_owner) {
        i_vaultSUSHI = new TimeLockedVault(ADDRESS_SUSHI, _owner);
        i_vaultUNI = new TimeLockedVault(ADDRESS_UNI, _owner);
        //i_vaultSOL = new TimeLockedVault(ADDRESS_SOL, _owner); NOT FOUND
        i_vaultMATIC = new TimeLockedVault(ADDRESS_MATIC, _owner);
        i_vaultCOMP = new TimeLockedVault(ADDRESS_COMP, _owner);
        i_vaultCRV = new TimeLockedVault(ADDRESS_CRV, _owner);
        i_vaultAVAX = new TimeLockedVault(ADDRESS_AVAX, _owner);
        //i_vaultARB = new TimeLockedVault(ADDRESS_ARB, _owner); NOT FOUND
        i_vaultAAVE = new TimeLockedVault(ADDRESS_AAVE, _owner);
        i_vaultAPE = new TimeLockedVault(ADDRESS_APE, _owner);
        i_vault1INCH = new TimeLockedVault(ADDRESS_1INCH, _owner);
        i_vaultPAXG = new TimeLockedVault(ADDRESS_PAXG, _owner);
        i_vaultSHIB = new TimeLockedVault(ADDRESS_SHIB, _owner);
        i_vaultUSDC = new TimeLockedVault(ADDRESS_USDC, _owner);
        i_vaultwETH = new TimeLockedVault(ADDRESS_wETH, _owner);
        i_vaultwBTC = new TimeLockedVault(ADDRESS_wBTC, _owner);

        perpetual = _perpetual;
    }
    
    /**
     * Transfer tokens to this contract and swap them using UniswapV3, a user that opens a position trades his tokens with another protocol
     * Example: if a user open a long position on wBTC using USDC as collateral, locks his USDC in the perpetual contract and trades USDC
     * from the vault for wBTC in this case, if the vault loses to much money because of it, he loses his USDC, if the vault gained money,
     * everyone gains money, after the position is closed, the wBTC is traded back to USDC.
     * In this case, if he opens a short position, the vault would first trade wBTC for USDC, if the price of wBTC goes down everyone gains money,
     * and them the wBTC is bought again after the position is closed.
     * It's necessary to check if the trade makes the user liquidatable, if it does, the transaction reverts
     */
    function requestTrade(address _tokenIn, uint256 totalCollateralTokenIn, address _tokenOut, uint256 amountBorrowedTokenOut, uint256 assetPrice) external returns (uint256 amountOut) {
        haltIfDepeged(_tokenIn, _tokenOut);
        if(msg.sender != address(perpetual)) revert TraderPolygon_SenderIsNotPerpetual(msg.sender);
        IERC20 tokenIn = IERC20(_tokenIn);
        IERC20 tokenOut = IERC20(_tokenOut);
        TimeLockedVault tokenVault = getVault(_tokenIn);
        
        tokenVault.transferTokenstoTrader(assetPrice); //assetPrice is equal to the debt, and the debt will be a mapping in the perpetual

        uint256 maximumIn = ((assetPrice * 2)/100) + assetPrice;

        amountOut = swapExactOutputSingle(tokenIn, amountBorrowedTokenOut, tokenOut, maximumIn);
    }

    function getLeverageAndPrice(address _tokenIn, uint256 totalCollateralTokenIn, address _tokenOut, uint256 amountBorrowedTokenOut) public view returns (uint32 leveragedValue, uint8 decimals, int256 assetPrice) {
        int256 minPrice;
        int256 maxPrice; // min and max price need to be defined based on what is on each contract, but that will take to long
        AggregatorV3Interface assetPriceFeed = getPriceFeedAddress(_tokenOut,_tokenIn); //example: ETH in USD
        decimals = assetPriceFeed.decimals();
        uint32 heartbeat = getHeartbeat(assetPriceFeed);
        (
            uint80 roundId, 
            int256 answer, 
            uint256 startedAt, 
            uint256 updatedAt, 
            uint80 answeredInRound
        ) = assetPriceFeed.latestRoundData(); // IT IS NECESSARY TO CHECK FOR CHAINLINK ERRORS HERE

        bool invalidPrice = roundId == 0 || answer <= minPrice || answer  >= maxPrice || block.timestamp - updatedAt >= heartbeat || block.timestamp - startedAt <= GRACE_PERIOD;
        if(invalidPrice) revert TraderPolygon_InvalidPrice(roundId, answer, startedAt, updatedAt, answeredInRound);

        assetPrice = int256(amountBorrowedTokenOut) * answer;

        leveragedValue = uint32((uint256(assetPrice) * LEVERAGE_PRECISION) / totalCollateralTokenIn); // precision is added
    }

    function getGainsOrLosses(address _tokenIn, address _tokenOut, uint256 amountBorrowedTokenOut, int256 debt) public view returns(int256 gainsOrLosses, int256 assetPrice) {
        int256 minPrice;
        int256 maxPrice;
        AggregatorV3Interface assetPriceFeed = getPriceFeedAddress(_tokenOut,_tokenIn);
        uint8 decimals = assetPriceFeed.decimals();
        uint32 heartbeat = getHeartbeat(assetPriceFeed);
        (
            uint80 roundId, 
            int256 answer, 
            uint256 startedAt, 
            uint256 updatedAt, 
            uint80 answeredInRound
        ) = assetPriceFeed.latestRoundData(); // IT IS NECESSARY TO CHECK FOR CHAINLINK ERRORS HERE

        bool invalidPrice = roundId == 0 || answer <= minPrice || answer  >= maxPrice || block.timestamp - updatedAt >= heartbeat || block.timestamp - startedAt <= GRACE_PERIOD;
        if(invalidPrice) revert TraderPolygon_InvalidPrice(roundId, answer, startedAt, updatedAt, answeredInRound);

        assetPrice = int256(amountBorrowedTokenOut) * answer;

        gainsOrLosses = assetPrice - debt;
    }

    function haltIfDepeged(address _tokenIn, address _tokenOut) public view {
        if(_tokenIn == ADDRESS_USDC || _tokenOut == ADDRESS_USDC) { 
        int256 minPrice;
        int256 maxPrice;
            AggregatorV3Interface usdcPriceFeed = getPriceFeedAddress(ADDRESS_USDC,ADDRESS_USDC);
            (
            uint80 roundId, 
            int256 priceUSDC, 
            uint256 startedAt, 
            uint256 updatedAt, 
            uint80 answeredInRound
        ) = usdcPriceFeed.latestRoundData();

        uint8 decimals = usdcPriceFeed.decimals();
        uint32 heartbeat = getHeartbeat(usdcPriceFeed);
        bool invalidPrice = roundId == 0 || priceUSDC <= minPrice || priceUSDC >= maxPrice || block.timestamp - updatedAt >= heartbeat || block.timestamp - startedAt <= GRACE_PERIOD;
        if(invalidPrice) revert TraderPolygon_InvalidPrice(roundId, priceUSDC, startedAt, updatedAt, answeredInRound);

        if(uint256(priceUSDC) > 102*(10**(decimals - 2)) || uint256(priceUSDC) < 98*(10**(decimals - 2))) revert TraderPolygon_USDCDepeged();
        }

        /* if(_tokenIn == ADDRESS_wBTC || _tokenOut == ADDRESS_wBTC) {
            AggregatorV3Interface wbtcPriceFeed = getPriceFeedAddress(ADDRESS_wBTC)(ADDRESS_wBTC);
            (
            uint80 roundId, 
            int256 pricewBTC, 
            uint256 startedAt, 
            uint256 updatedAt, 
            uint80 answeredInRound
        ) = wbtcPriceFeed.latestRoundData();
        uint8 decimals = wbtctPriceFeed.decimals();
        if(pricewBTC > 102**(decimals - 2) || pricewBTC < 98**(decimals - 2)) revert TraderPolygon_wBTCDepeged();
        } */
    }

   /*  function ExchangeETHtoERC20(address tokenOut) public payable returns (uint256 amountOut) {
        msg.value;
    } */

    //receive() external payable {}

    function swapExactInputSingle(IERC20 tokenIn, uint256 amountIn, IERC20 tokenOut, uint256 amountOutMinimum)
        internal
        returns (uint256 amountOut)
    {
        tokenIn.approve(address(i_swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: address(tokenIn),
                tokenOut: address(tokenOut),
                fee: POOL_FEE,
                recipient: address(this),
                deadline: block.timestamp, //add some time here
                amountIn: amountIn,
                amountOutMinimum: amountOutMinimum,
                sqrtPriceLimitX96: 0
            });

        amountOut = i_swapRouter.exactInputSingle(params);
    }

    function swapExactOutputSingle(IERC20 tokenIn, uint256 amountOut, IERC20 tokenOut, uint256 amountInMaximum)
        internal
        returns (uint256 amountIn)
    {
        tokenIn.approve(address(i_swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter
            .ExactOutputSingleParams({
                tokenIn: address(tokenIn),
                tokenOut: address(tokenOut),
                fee: POOL_FEE,
                recipient: address(this),
                deadline: block.timestamp, //add some time here
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        amountIn = i_swapRouter.exactOutputSingle(params);

        if (amountIn < amountInMaximum) {
            tokenIn.approve(address(i_swapRouter), 0);
            tokenIn.transfer(address(this), amountInMaximum - amountIn);
        }
    }

    function getVault(address token) public view returns(TimeLockedVault) {

        if (token == ADDRESS_wBTC) return i_vaultwBTC;

        else if (token == ADDRESS_wETH) return i_vaultwETH;

        else if (token == ADDRESS_USDC) return i_vaultUSDC;

        else if (token == ADDRESS_SHIB) return i_vaultSHIB;

        else if (token == ADDRESS_APE) return i_vaultAPE;

        else if (token == ADDRESS_PAXG) return i_vaultPAXG;

        else if (token == ADDRESS_1INCH) return i_vault1INCH;

        else if (token == ADDRESS_AAVE) return i_vaultAAVE;

        else if (token == ADDRESS_AVAX) return i_vaultAVAX;

        //else if (token == ADDRESS_SOL) return i_vaultCOMP;

        //else if (token == ADDRESS_ARB) return i_vaultARB;

        else if (token == ADDRESS_CRV) return i_vaultCRV;

        else if (token == ADDRESS_COMP) return i_vaultCOMP;
        
        else if (token == ADDRESS_MATIC) return i_vaultMATIC;

        else if (token == ADDRESS_UNI) return i_vaultUNI;

        else if (token == ADDRESS_SUSHI) return i_vaultSUSHI;
    }
}
