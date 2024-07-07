// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { AggregatorV3Interface } from "../Interfaces/ChainLink/AggregatorV3Interface.sol";

contract MainNetPureFunctions {

    error PriceFeedNotFound(address from, address to);

    error AggregratorNotFound(AggregatorV3Interface aggregator);

    address constant ADDRESS_wBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address constant ADDRESS_wETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant ADDRESS_USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant ADDRESS_SHIB = 0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE;
    address constant ADDRESS_APE = 0x4d224452801ACEd8B2F0aebE155379bb5D594381;
    address constant ADDRESS_PAXG = 0x45804880De22913dAFE09f4980848ECE6EcbAf78;
    address constant ADDRESS_1INCH = 0x111111111117dC0aa78b770fA6A738034120C302;
    address constant ADDRESS_AAVE = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
    address constant ADDRESS_AVAX = 0x85f138bfEE4ef8e540890CFb48F620571d67Eda3;
    address constant ADDRESS_SOL = 0xD31a59c85aE9D8edEFeC411D448f90841571b89c;
    address constant ADDRESS_ARB = 0xB50721BCf8d664c30412Cfbc6cf7a15145234ad1;
    address constant ADDRESS_CRV = 0xD533a949740bb3306d119CC777fa900bA034cd52;
    address constant ADDRESS_COMP = 0xc00e94Cb662C3520282E6f5717214004A7f26888;
    address constant ADDRESS_MATIC = 0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0;
    address constant ADDRESS_UNI = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
    address constant ADDRESS_SUSHI = 0x6B3595068778DD592e39A122f4f5a5cF09C90fE2; 

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
    AggregatorV3Interface constant MainNetSOLtoUSD = AggregatorV3Interface(0x4ffC43a60e009B551865A93d232E33Fce9f01507);
    AggregatorV3Interface constant MainNetADAtoUSD = AggregatorV3Interface(0x882554df528115a743c4537828DA8D5B58e52544);
    AggregatorV3Interface constant MainNetAVAXtoUSD = AggregatorV3Interface(0xFF3EEb22B5E3dE6e705b44749C2559d704923FD7);
    AggregatorV3Interface constant MainNetAAVEtoUSD = AggregatorV3Interface(0x547a514d5e3769680Ce22B2361c10Ea13619e8a9);
    AggregatorV3Interface constant MainNetAAVEtoETH = AggregatorV3Interface(0x6Df09E975c830ECae5bd4eD9d90f3A95a4f88012);
    AggregatorV3Interface constant MainNetARBtoUSD = AggregatorV3Interface(0x31697852a68433DbCc2Ff612c516d69E3D9bd08F);
    AggregatorV3Interface constant MainNetAPEtoUSD = AggregatorV3Interface(0xD10aBbC76679a20055E167BB80A24ac851b37056);
    AggregatorV3Interface constant MainNetAPEtoETH = AggregatorV3Interface(0xc7de7f4d4C9c991fF62a07D18b3E31e349833A18);
    AggregatorV3Interface constant MainNetCOMPtoUSD = AggregatorV3Interface(0xdbd020CAeF83eFd542f4De03e3cF0C28A4428bd5);
    AggregatorV3Interface constant MainNetCOMPtoETH = AggregatorV3Interface(0x1B39Ee86Ec5979ba5C322b826B3ECb8C79991699);
    AggregatorV3Interface constant MainNet1INCHtoUSD = AggregatorV3Interface(0xc929ad75B72593967DE83E7F7Cda0493458261D9);
    AggregatorV3Interface constant MainNet1INCHtoETH = AggregatorV3Interface(0x72AFAECF99C9d9C8215fF44C77B94B99C28741e8);
    AggregatorV3Interface constant MainNetCRVtoUSD = AggregatorV3Interface(0xCd627aA160A6fA45Eb793D19Ef54f5062F20f33f);
    AggregatorV3Interface constant MainNetCRVtoETH = AggregatorV3Interface(0x8a12Be339B0cD1829b91Adc01977caa5E9ac121e);
    AggregatorV3Interface constant MainNetUNItoUSD = AggregatorV3Interface(0x553303d460EE0afB37EdFf9bE42922D8FF63220e);
    AggregatorV3Interface constant MainNetUNItoETH = AggregatorV3Interface(0xD6aA3D25116d8dA79Ea0246c4826EB951872e02e);
    AggregatorV3Interface constant MainNetSUSHItoUSD = AggregatorV3Interface(0xCc70F09A6CC17553b2E31954cD36E4A2d89501f7);
    AggregatorV3Interface constant MainNetSUSHItoETH = AggregatorV3Interface(0xe572CeF69f43c2E488b33924AF04BDacE19079cf);

    function getLeverage(int256 collateral, int256 amountBorrowed, int256 difference, uint8 initialLeverage) public pure returns (int256 leverage) {
        leverage = (amountBorrowed/(collateral + difference));
    }

    function isLiquidatable(int256 collateral, int256 amountBorrowed, int256 difference, uint8 initialLeverage) public pure returns (bool isLiquidatable) {
        //if(collateral + difference < 0) return true;
        int256 leverage = getLeverage(collateral, amountBorrowed, difference, initialLeverage);
        isLiquidatable = leverage > ((amountBorrowed/collateral)*5); // if collateral + difference < 0 will it revert?
    }

    function getPriceFeedAddress(address from, address to) public pure returns(AggregatorV3Interface) {
        if(to == ADDRESS_USDC){

            if(from == ADDRESS_wBTC) return MainNetBTCtoUSD;

            else if(from == ADDRESS_wETH) return MainNetETHtoUSD;

            else if(from == ADDRESS_1INCH) return MainNet1INCHtoUSD;

            else if(from == ADDRESS_USDC) return MainNetUSDCtoUSD;

            else if(from == ADDRESS_MATIC) return MainNetMATICtoUSD;

            else if(from == ADDRESS_APE) return MainNetAPEtoUSD;

            else if(from == ADDRESS_ARB) return MainNetARBtoUSD;

            else if(from == ADDRESS_AVAX) return MainNetAVAXtoUSD;

            else if(from == ADDRESS_AAVE) return MainNetAAVEtoUSD;

            else if(from == ADDRESS_SOL) return MainNetSOLtoUSD;

            else if(from == ADDRESS_CRV) return MainNetCRVtoUSD;

            else if(from == ADDRESS_COMP) return MainNetCOMPtoUSD;

            else if(from == ADDRESS_UNI) return MainNetUNItoUSD;

            else if(from == ADDRESS_SUSHI) return MainNetSUSHItoUSD;

            else revert PriceFeedNotFound(from, to);
        }

        else if(to == ADDRESS_wETH){

            if(from == ADDRESS_wBTC) return MainNetBTCtoETH;

            else if(from == ADDRESS_1INCH) return MainNet1INCHtoETH;

            else if(from == ADDRESS_APE) return MainNetAPEtoETH;

            else if(from == ADDRESS_SHIB) return MainNetSHIBtoETH;

            else if(from == ADDRESS_PAXG) return MainNetPAXGtoETH;

            else if(from == ADDRESS_AAVE) return MainNetAAVEtoETH;

            //else if(from == ADDRESS_SOL) return MainNetSOLtoETH;

            else if(from == ADDRESS_CRV) return MainNetCRVtoETH;

            else if(from == ADDRESS_COMP) return MainNetCOMPtoETH;

            else if(from == ADDRESS_UNI) return MainNetUNItoETH;

            else if(from == ADDRESS_SUSHI) return MainNetSUSHItoETH;

            //else if(from == ADDRESS_MATIC) return MainNetMATICtoETH;

            else revert PriceFeedNotFound(from, to);
        }

        else if(to == ADDRESS_wBTC) {

            if(from == ADDRESS_wBTC) return MainNetWBTCtoBTC;

            else if(from == ADDRESS_wETH) return MainNetETHtoBTC;

            else revert PriceFeedNotFound(from, to);
        }

        else revert PriceFeedNotFound(from, to);
    }

    function getHeartbeat(AggregatorV3Interface aggregator) public pure returns(uint32 heartbeat) {

        if(
            aggregator == MainNetETHtoUSD ||
            aggregator == MainNetBTCtoUSD ||
            aggregator == MainNetUSDCtoUSD ||
            aggregator == MainNetAAVEtoUSD ||
            aggregator == MainNetCOMPtoUSD ||
            aggregator == MainNetMATICtoUSD || 
            aggregator == MainNetSUSHItoUSD ||
            aggregator == MainNetUNItoUSD ||
            aggregator == MainNetETHtoBTC
            ) 
            return heartbeat = 3600;

        else if(
            aggregator == MainNet1INCHtoUSD ||
            aggregator == MainNetAPEtoUSD ||
            aggregator == MainNetARBtoUSD ||
            aggregator == MainNetAVAXtoUSD ||
            aggregator == MainNetSOLtoUSD ||
            aggregator == MainNetCRVtoUSD ||
            aggregator == MainNet1INCHtoETH ||
            aggregator == MainNetAPEtoETH ||
            aggregator == MainNetSHIBtoETH ||
            aggregator == MainNetPAXGtoETH ||
            aggregator == MainNetAAVEtoETH ||
            aggregator == MainNetCRVtoETH ||
            aggregator == MainNetCOMPtoETH ||
            aggregator == MainNetUNItoETH ||
            aggregator == MainNetSUSHItoETH ||
            aggregator == MainNetWBTCtoBTC
            ) return heartbeat = 86400;
    }
    
}