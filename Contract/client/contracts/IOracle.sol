// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.2;

interface IOracle {
    function requestWinnerFight() external returns (uint256);
}