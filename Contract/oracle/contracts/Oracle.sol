// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./ICaller.sol";

/**
 * @title Sample Contract Oraculo.
 * @dev This contract is a basic implementation of an oracle.
 */
contract Oracle is AccessControl {
    bytes32 public constant PROVIDER_ROLE = keccak256("PROVIDER_ROLE");
    uint private numProviders = 0;
    uint private providersThreshold = 1;
    uint private randNonce = 0;

    mapping(uint256 => bool) private pendingRequests;

    struct Response {
        address providerAddress;
        address callerAddress;
        string winnerFight;
    }

    mapping(uint256 => Response[]) private idToResponses;

    event WinnerFightRequested(address callerAddress, uint id);
    event WinnerFightReturned(
        string winnerFight,
        address callerAddress,
        uint id
    );
    event ProviderAdded(address providerAddress);
    event ProviderRemoved(address providerAddress);
    event ProvidersThresholdChanged(uint threshold);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @dev Generates a unique ID for the request, based on randNonce and increments pending requests with that id.
     * @return Unique identifier generated for the request.
     */
    function requestWinnerFight() external returns (uint256) {
        require(numProviders > 0, " No data providers not yet added.");

        randNonce++;
        uint id = uint(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))
        ) % 1000;
        pendingRequests[id] = true;

        emit WinnerFightRequested(msg.sender, id);
        return id;
    }

    /**
     * @dev Function to handle the suppliers' response to a request for a winner's fight.
     * @param winnerFight The result of the winner's fight.
     * @param callerAddress The address of the original applicant.
     * @param id The unique identifier of the request.
     */
    function returnWinnerFight(
        string memory winnerFight,
        address callerAddress,
        uint256 id
    ) external onlyRole(PROVIDER_ROLE) {
        require(pendingRequests[id], "Request not found.");

        Response memory res = Response(msg.sender, callerAddress, winnerFight);
        idToResponses[id].push(res);
        uint numResponses = idToResponses[id].length;

        if (numResponses == providersThreshold) {
            uint last = idToResponses[id].length - 1;
            string memory finalWinnerFight = idToResponses[id][last]
                .winnerFight;

            // Create a logic to get the name of the most repeated winner.

            delete pendingRequests[id];
            delete idToResponses[id];

            ICaller(callerAddress).fullfillWinnerFightRequest(winnerFight, id);

            emit WinnerFightReturned(finalWinnerFight, callerAddress, id);
        }
    }

    /**
     * @dev The function to add a provider.
     * @param provider The address of the provider to add.
     */
    function addProvider(
        address provider
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(!hasRole(PROVIDER_ROLE, provider), "Provider already added.");

        _grantRole(PROVIDER_ROLE, provider);
        numProviders++;

        emit ProviderAdded(provider);
    }

    /**
     * @dev Function to remove a provider.
     * @param provider The address of the provider to remove.
     */
    function removeProvider(
        address provider
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(
            !hasRole(PROVIDER_ROLE, provider),
            "Address is not a recognized provider."
        );
        require(numProviders > 1, "Cannot remove the only provider.");

        _revokeRole(PROVIDER_ROLE, provider);
        numProviders--;
        emit ProviderRemoved(provider);
    }

    /**
     * @dev Function to set the provider threshold.
     * @param threshold The new provider threshold.
     */
    function setProvidersThreshold(
        uint threshold
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(threshold > 0, "Threshold cannot be zero.");

        providersThreshold = threshold;
        emit ProvidersThresholdChanged(providersThreshold);
    }
}
