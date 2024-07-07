// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface Perpetual {

    function openPositionLong(address token, uint256 amount) external;

    function openPositionShort(address token, uint256 amount) external;

    function calculateHealthFactor(uint256 collateral, uint256 amountBorrowed, int256 gains) external pure returns (bool);
}
