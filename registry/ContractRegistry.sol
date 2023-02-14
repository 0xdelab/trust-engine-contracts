// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract ContractRegistry {

    address private owner;

    event ContractRegistered(bytes32 userId, bytes32 contractName, bytes32 contractType, address contractAddress);

    event ContractUnregistered(address contractAddress);

    struct ContractInfo {
        bytes32 userId;
        bytes32 contractName;
        bytes32 contractType;
        address contractAddress;
    }

    mapping(bytes32 => mapping(bytes32 => ContractInfo)) allContracts;

    constructor() {
        owner = msg.sender;
    }

    function registerContract(
        bytes32 userId,
        bytes32 contractName,
        bytes32 contractType,
        address contractAddress
    ) public onlyAuthorized {
        // TODO: only if managed
        allContracts[userId][contractName] = ContractInfo(userId, contractName, contractType, contractAddress);

        emit ContractRegistered(userId, contractName, contractType, contractAddress);
    }

    modifier onlyAuthorized {
        require(
            msg.sender == owner,
            "Sender is not authorized"
        );
        _;
    }    
}
