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

/*
contract TraderMainet is Ownable {
    using SafeERC20 for IERC20;

     uint256 constant POOL_FEE = 3000;

    TimeLockedVault immutable i_vaultwBTC;
    TimeLockedVault immutable i_vaultwETH;
    TimeLockedVault immutable i_vaultUSDC;
    TimeLockedVault immutable i_vaultSHIB;
    TimeLockedVault immutable i_vaultAPE;
    TimeLockedVault immutable i_vaultPAXG;
    TimeLockedVault immutable i_vault1NCH;
    TimeLockedVault immutable i_vaultAAVE;
    //TimeLockedVault immutable i_vaultARB; NOT FOUND
    TimeLockedVault immutable i_vaultAVAX;
    TimeLockedVault immutable i_vaultCURVE;
    TimeLockedVault immutable i_vaultCOMP;
    TimeLockedVault immutable i_vaultMATIC;
    //TimeLockedVault immutable i_vaultSOL; NOT FOUND
    TimeLockedVault immutable i_vaultUNI;
    TimeLockedVault immutable i_vaultSUSHI;

    address constant ADDRESS_wBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address constant ADDRESS_wETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant ADDRESS_USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant ADDRESS_SHIB = 0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE;
    address constant ADDRESS_APE = 0x4d224452801ACEd8B2F0aebE155379bb5D594381;
    address constant ADDRESS_PAXG = 0x45804880De22913dAFE09f4980848ECE6EcbAf78;
    address constant ADDRESS_1NCH = 0x111111111117dC0aa78b770fA6A738034120C302;
    address constant ADDRESS_AAVE = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
    //address constant ADDRESS_ARB = 0x???????????????????????????????????????; NOT FOUND
    address constant ADDRESS_CURVE = 0xD533a949740bb3306d119CC777fa900bA034cd52;
    address constant ADDRESS_COMP = 0xc00e94Cb662C3520282E6f5717214004A7f26888;
    address constant ADDRESS_MATIC = 0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0;
    //address constant ADDRESS_SOL = 0x?????????????????????????????????????????; NOT FOUND
    address constant ADDRESS_UNI = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
    address constant ADDRESS_SUSHI = 0x6B3595068778DD592e39A122f4f5a5cF09C90fE2;   

    mapping(address => TimeLockedVault) tokenToVault;

    address public constant routerAddress = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    ISwapRouter public immutable swapRouter = ISwapRouter(routerAddress);

    //IERC20 constant USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    AggregatorV3Interface constant MainNetUSDCtoETH = AggregatorV3Interface(0x986b5E1e1755e3C2440e960477f25201B0a8bbD4);
    AggregatorV3Interface constant MainNetETHtoUSD = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    AggregatorV3Interface constant MainNetBTCtoUSD = AggregatorV3Interface(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c);
    AggregatorV3Interface constant MainNetWBTCtoBTC = AggregatorV3Interface(0xfdFD9C85aD200c506Cf9e21F1FD8dd01932FBB23);
    AggregatorV3Interface constant MainNetETHtoBTC = AggregatorV3Interface(0xAc559F25B1619171CbC396a50854A3240b6A4e99);
    AggregatorV3Interface constant MainNetBTCtoETH = AggregatorV3Interface(0xdeb288F737066589598e9214E782fa5A8eD689e8);
    AggregatorV3Interface constant MainNetUSDCtoUSD = AggregatorV3Interface(0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6);
    AggregatorV3Interface constant MainNetSHIBtoETH = AggregatorV3Interface(0x8dD1CD88F43aF196ae478e91b9F5E4Ac69A97C61);
    AggregatorV3Interface constant MainNetPAXGtoETH = AggregatorV3Interface(0x9B97304EA12EFed0FAd976FBeCAad46016bf269e);
    AggregatorV3Interface constant MainNetMATICtoUSD = AggregatorV3Interface(0x7bAC85A8a13A4BcD8abb3eB7d6b4d632c5a57676);
    //AggregatorV3Interface constant MainNetSOLtoUSD = AggregatorV3Interface(0x4ffC43a60e009B551865A93d232E33Fce9f01507);
    AggregatorV3Interface constant MainNetAVAXtoUSD = AggregatorV3Interface(0xFF3EEb22B5E3dE6e705b44749C2559d704923FD7);
    AggregatorV3Interface constant MainNetAAVEtoUSD = AggregatorV3Interface(0x547a514d5e3769680Ce22B2361c10Ea13619e8a9);
    AggregatorV3Interface constant MainNetAAVEtoETH = AggregatorV3Interface(0x6Df09E975c830ECae5bd4eD9d90f3A95a4f88012);
    //AggregatorV3Interface constant MainNetARBtoUSD = AggregatorV3Interface(0x31697852a68433DbCc2Ff612c516d69E3D9bd08F);
    AggregatorV3Interface constant MainNetAPEtoUSD = AggregatorV3Interface(0xD10aBbC76679a20055E167BB80A24ac851b37056);
    AggregatorV3Interface constant MainNetAPEtoETH = AggregatorV3Interface(0xc7de7f4d4C9c991fF62a07D18b3E31e349833A18);
    AggregatorV3Interface constant MainNetCOMPtoUSD = AggregatorV3Interface(0xdbd020CAeF83eFd542f4De03e3cF0C28A4428bd5);
    AggregatorV3Interface constant MainNetCOMPtoETH = AggregatorV3Interface(0x1B39Ee86Ec5979ba5C322b826B3ECb8C79991699);
    AggregatorV3Interface constant MainNet1NCHtoUSD = AggregatorV3Interface(0xc929ad75B72593967DE83E7F7Cda0493458261D9);
    AggregatorV3Interface constant MainNet1NCHtoETH = AggregatorV3Interface(0x72AFAECF99C9d9C8215fF44C77B94B99C28741e8);
    AggregatorV3Interface constant MainNetCURVEtoUSD = AggregatorV3Interface(0xCd627aA160A6fA45Eb793D19Ef54f5062F20f33f);
    AggregatorV3Interface constant MainNetCURVEtoETH = AggregatorV3Interface(0x8a12Be339B0cD1829b91Adc01977caa5E9ac121e);
    AggregatorV3Interface constant MainNetUNItoUSD = AggregatorV3Interface(0x553303d460EE0afB37EdFf9bE42922D8FF63220e);
    AggregatorV3Interface constant MainNetUNItoETH = AggregatorV3Interface(0xD6aA3D25116d8dA79Ea0246c4826EB951872e02e);
    AggregatorV3Interface constant MainNetSUHItoUSD = AggregatorV3Interface(0xCc70F09A6CC17553b2E31954cD36E4A2d89501f7);
    AggregatorV3Interface constant MainNetSUHItoETH = AggregatorV3Interface(0xe572CeF69f43c2E488b33924AF04BDacE19079cf);

    mapping(address => mapping(address => AggregatorV3Interface)) tokenToTokenToAggregator;


    constructor () {
        i_vaultSUSHI = new TimeLockedVault(ADDRESS_SUSHI);
        i_vaultUNI = new TimeLockedVault(ADDRESS_UNI);
        //i_vaultSOL = new TimeLockedVault(ADDRESS_SOL); NOT FOUND
        i_vaultMATIC = new TimeLockedVault(ADDRESS_MATIC);
        i_vaultCOMP = new TimeLockedVault(ADDRESS_COMP);
        i_vaultCURVE = new TimeLockedVault(ADDRESS_CURVE);
        i_vaultAVAX = new TimeLockedVault(ADDRESS_AVAX);
        //i_vaultARB = new TimeLockedVault(ADDRESS_ARB); NOT FOUND
        i_vaultAAVE = new TimeLockedVault(ADDRESS_AAVE);
        i_vaultAPE = new TimeLockedVault(ADDRESS_APE);
        i_vault1NCH = new TimeLockedVault(ADDRESS_1NCH);
        i_vaultPAXG = new TimeLockedVault(ADDRESS_PAXG);
        i_vaultSHIB = new TimeLockedVault(ADDRESS_SHIB);
        i_vaultUSDC = new TimeLockedVault(ADDRESS_USDC);
        i_vaultwETH = new TimeLockedVault(ADDRESS_wETH);
        i_vaultwBTC = new TimeLockedVault(ADDRESS_wBTC);


        tokenToTokenToAggregator[ADDRESS_wBTC][ADDRESS_USDC] = MainNetBTCtoUSD;
        tokenToTokenToAggregator[ADDRESS_wETH][ADDRESS_USDC] = MainNetETHtoUSD;
        tokenToTokenToAggregator[ADDRESS_1NCH][ADDRESS_USDC] = MainNet1NCHtoUSD;
        tokenToTokenToAggregator[ADDRESS_APE][ADDRESS_USDC] = MainNetAPEtoUSD;
        tokenToTokenToAggregator[ADDRESS_AVAX][ADDRESS_USDC] = MainNetAVAXtoUSD;
        tokenToTokenToAggregator[ADDRESS_AAVE][ADDRESS_USDC] = MainNetAAVEtoUSD;
        tokenToTokenToAggregator[ADDRESS_CURVE][ADDRESS_USDC] = MainNetCURVEtoUSD;
        tokenToTokenToAggregator[ADDRESS_COMP][ADDRESS_USDC] = MainNetCOMPtoUSD;
        tokenToTokenToAggregator[ADDRESS_MATIC][ADDRESS_USDC] = MainNetMATICtoUSD;
        tokenToTokenToAggregator[ADDRESS_UNI][ADDRESS_USDC] = MainNetUNItoUSD;
        tokenToTokenToAggregator[ADDRESS_SUSHI][ADDRESS_USDC] = MainNetSUHItoUSD;

        Perpetual perpetual = new Perpetual();
    }
    
    function requestTrade(address _tokenIn, uint256 amountBorrowedIn, address _tokenOut, uint256 collateral) public returns (uint256 amountOut) {
        IERC20 tokenIn = IERC20(_tokenIn);
        IERC20 tokenOut = IERC20(_tokenOut);
        TimeLockedVault tokenVault = tokenToVault[_tokenIn];
        
        tokenVault.transferTokenstoTrader(amountBorrowedIn);

        swapExactInputSingle(tokenIn, amount, tokenOut, price);
    }

    function verifyLeverage(address _tokenIn, uint256 amountBorrowedIn, address _tokenOut, uint256 collateral) public returns (uint256 leveragedValue, uint256){
        AggregatorV3Interface assetToUSD = tokenToTokenToAggregator[_tokenOut][_tokenIn];
        ( , int256 priceUSD, , , ) = assetToUSD.latestRoundData;
        if(perpetual.calculateHealthFactor(,,))
            revert;
    }

    receive() external payable {}

    function swapExactInputSingle(IERC20 tokenIn, uint256 amountIn, IERC20 tokenOut, uint256 amountOutMinimum)
        internal
        returns (uint256 amountOut)
    {
        tokenIn.approve(address(swapRouter), amountIn);

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

        amountOut = swapRouter.exactInputSingle(params);
    }

    function swapExactOutputSingle(IERC20 tokenIn, uint256 amountOut, IERC20 tokenOut, uint256 amountInMaximum)
        internal
        returns (uint256 amountIn)
    {
        tokenIn.approve(address(swapRouter), amountInMaximum);

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

        amountIn = swapRouter.exactOutputSingle(params);

        if (amountIn < amountInMaximum) {
            tokenIn.approve(address(swapRouter), 0);
            tokenIn.transfer(address(this), amountInMaximum - amountIn);
        }
    } 
}*/
