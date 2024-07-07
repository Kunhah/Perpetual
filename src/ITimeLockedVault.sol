// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { ERC4626 } from "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import { IERC20 } from "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "../node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface ITimeLockedVault {

    function transferTokenstoTrader(uint256 amount) external;

    function depositDefiningTimeLock(uint256 assets, address receiver, uint64 lockedTime) external returns (uint256);

    function withdrawWithTimeLock(uint256 assets, address receiver, address owner) external returns (uint256);

    function redeemWithTimeLock(uint256 shares, address receiver, address owner) external returns (uint256);

    function calculateRewardPercentage() external view returns(uint64);
}