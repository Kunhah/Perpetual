// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { TraderPolygon } from "./TraderPolygon.sol";
import { IERC20 } from "../../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { PolygonPureFunctions } from "./PolygonPureFunctions.sol";

contract Perpetual {

    uint256 constant POOL_FEE = 3000;
    uint256 constant GRACE_PERIOD = 3600;
    uint256 constant LEVERAGE_PRECISION = 1000000;
/*     uint32 constant LEVERAGE_FLOOR = 10;
    uint32 constant LEVERAGE_LIMIT = 200; */

    TraderPolygon immutable trader;

    error Perpetual_NotLiquidatable(uint32 leveragedValue, uint32 leverageLimit);

    // user => tokenIn => tokenOut => amountTokensBorrowed or debt or collateral
    mapping(address =>  mapping(address =>  mapping(address => int256))) debt;
    mapping(address =>  mapping(address =>  mapping(address => uint256))) amountBorrowedTokenOut;
    mapping(address =>  mapping(address =>  mapping(address => int256))) collateralDeposited;
    //mapping(address => uint8) initialLeverage;

    constructor(address _trader) {
        trader = TraderPolygon(_trader);
    }

    function openPositionLong(address token, uint256 amount) public {

    }

    function _liquidate(address user, address tokenIn, address tokenOut) internal {
        (uint32 leveragedValue, uint32 leverageLimit, bool isLiquidatable) = checkIsUserLiquidatable(user, tokenIn, tokenOut);
        if(!isLiquidatable) revert Perpetual_NotLiquidatable(leveragedValue, leverageLimit);


    }

    // I want to make an algorithm that multiplies the initial leverage and gives a lower result for bigger borrows

    function checkIsUserLiquidatable(address user, address _tokenIn, address _tokenOut) public view returns(uint32 leveragedValue, uint32 leverageLimit, bool isLiquidatable) {
        int256 debt = debt[user][_tokenIn][_tokenOut];
        uint256 amountBorrowedTokenOut = amountBorrowedTokenOut[user][_tokenIn][_tokenOut];
        int256 collateralDeposited = collateralDeposited[user][_tokenIn][_tokenOut];
        (int256 gainsOrLosses,) = trader.getGainsOrLosses( _tokenIn, _tokenOut, amountBorrowedTokenOut, debt);
        if(collateralDeposited + gainsOrLosses <= 0) {
            return (leveragedValue = type(uint32).max, 0, true);
        }
        uint256 totalCollateralTokenIn = uint256(collateralDeposited + gainsOrLosses); // This will revert if (collateralDeposited + gainsOrLosses < 0)
        (uint32 leveragedValue, uint8 decimals, ) = trader.getLeverageAndPrice(_tokenIn, totalCollateralTokenIn, _tokenOut, amountBorrowedTokenOut);
        leverageLimit = getLeverageLimit(amountBorrowedTokenOut, decimals);
        if(leveragedValue > leverageLimit) isLiquidatable = true;
    }

    function getLeverageLimit(uint256 amountBorrowedTokenOut, uint8 decimals) public pure returns(uint32 leverageLimit) {

        leverageLimit = uint32(((19990 * LEVERAGE_PRECISION * (10**decimals))/amountBorrowedTokenOut) + (10**(decimals + 1)));
        
        /* if( < LEVERAGE_FLOOR) return LEVERAGE_FLOOR;
        else if ( > LEVERAGE_LIMIT) return LEVERAGE_LIMIT
        else return; */
    }


}
