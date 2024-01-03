// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

interface ICaller {
    function fullfillWinnerFightRequest(string memory winnerFight, uint256 id) external;
}