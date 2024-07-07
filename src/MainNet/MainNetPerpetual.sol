// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { TraderMainNet } from "./TraderMainNet.sol";
import { IERC20 } from "../../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { MainNetPureFunctions } from "./MainNetPureFunctions.sol";

contract Perpetual is MainNetPureFunctions {

    TraderMainNet immutable traderMainNet;

    error Perpetual_NotLiquidatable(int256 leverage);

    mapping(address => mapping(address => uint256)) public collateralDeposited; 

    constructor(address _traderMainNet) {
        //traderMainNet = TraderMainNet(_traderMainNet);
    }

    function openPositionLong(address token, uint256 amount) public {

    }

    /* function _liquidate(int256 collateral, int256 amountBorrowed, int256 difference, uint8 initialLeverage) internal {
        bool isLiquidatable = isLiquidatable(collateral, amountBorrowed, difference, initialLeverage);
        if(!isLiquidatable) revert Perpetual_NotLiquidatable(leverage);


    } */


}
