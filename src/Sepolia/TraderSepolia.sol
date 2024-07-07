// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { AggregatorV3Interface } from "../Interfaces/ChainLink/AggregatorV3Interface.sol";
//import { UniswapExchangeInterface } from "../Interfaces/UniSwap/UniswapV3ExchangeInterface.sol";
import { IERC20 } from "../../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "../../node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { Ownable } from "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import { ISwapRouter } from "../../node_modules/@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
//import { TimedLockedVault } from "../TimeLockedVault.sol";
import { ITimeLockedVault } from "../ITimeLockedVault.sol";
//import { Perpetual } from "../Perpetual.sol";

contract Trader {

    AggregatorV3Interface constant SepoliaUSDCtoUSD = AggregatorV3Interface(0xA2F78ab2355fe2f984D808B5CeE7FD0A93D5270E);
    AggregatorV3Interface constant SepoliaETHtoUSD = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    AggregatorV3Interface constant SepoliaBTCtoUSD = AggregatorV3Interface(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43);
    

    function openPositionLong(address token, uint256 amount) public {
        
    }
}
