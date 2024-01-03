//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IOracle.sol";

/**
 * @title Sample Contract Caller.
 * @dev This contract allows interaction with an oracle contract.
 */
contract Caller is Ownable {
    IOracle private oracle;
    address private _owner;

    mapping(uint256 => bool) requests;
    mapping(uint256 => string) results;

    event OracleAddressChanged(address oracleAddress);
    event WinnerFightRequested(uint256 id);
    event WinnerFightReceived(string winner, uint256 id);

    modifier onlyOracle() {
        require(msg.sender == address(oracle), "Unauthorized.");
        _;
    }

    /**
     * @dev The constructor of the contract.
     * @param initialOwner The address that will initially own the contract.
     */
    constructor(address initialOwner) Ownable(initialOwner) {
        _owner = initialOwner;
    }

    /**
     * @dev Function to set the oracle contract address.
     * @param newAddress The new address of the oracle contract.
     */
    function setOracleAddress(address newAddress) external onlyOwner {
        oracle = IOracle(newAddress);

        emit OracleAddressChanged(newAddress);
    }

    /**
     * @dev Function to request a winner fight to the oracle contract.
     */
    function getWinnerFight() external {
        require(oracle != IOracle(address(0)), "Oracle not initialized.");

        uint256 id = oracle.requestWinnerFight();
        requests[id] = true;

        emit WinnerFightRequested(id);
    }

    /**
     * @dev Function to fulfill a winner fight request.
     * @param winnerFight The result of the winner fight.
     * @param id The unique identifier of the request.
     */
    function fullfillWinnerFightRequest(
        string memory winnerFight,
        uint256 id
    ) external onlyOracle {
        require(requests[id], "Request is invalid or already fulfilled.");

        results[id] = winnerFight;
        delete requests[id];

        emit WinnerFightReceived(winnerFight, id);
    }
}
