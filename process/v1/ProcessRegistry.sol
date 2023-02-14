// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract ProcessRegistry {

    struct ProcessState {
        mapping(bytes32 => bool) hashSet;
        mapping(bytes32 => bytes32[]) transitions;
        bool isValue;
    }

    address private owner;

    mapping(bytes32 => ProcessState) allProcesses;
    mapping(bytes32 => mapping(bytes32 => bool)) signerSet;

    event ProcessCreated(bytes32 processId, bytes32 initialHash, bytes32[] signers);

    event ProcessSigned(bytes32 processId, bytes32 fromHash, bytes32 toHash, bytes32 signer);

    constructor() {
        owner = msg.sender;
    }

    function createProcess(
        bytes32 processId,
        bytes32 initialHash,
        bytes32[] memory signers
    ) public onlyAuthorized returns (bytes32) {
        owner = msg.sender;

        require(
            !allProcesses[processId].isValue,
            "Process already exists"
        );

        ProcessState storage newState = allProcesses[processId];
        newState.hashSet[initialHash] = true;
        newState.transitions[initialHash] = new bytes32[](2);
        newState.isValue = true;

        for (uint256 i = 0; i < signers.length; i++) {
            bytes32 signer = signers[i];
            signerSet[processId][signer] = true;
        }

        emit ProcessCreated(processId, initialHash, signers);

        return processId;
    }

    function sign(
        bytes32 processId,
        bytes32 signer,
        bytes32 fromHash,
        bytes32 toHash
    ) public onlyAuthorized {
        ProcessState storage currState = allProcesses[processId];

        require(
            currState.isValue,
            "ProcessId does not exist"
        );

        require(
            currState.hashSet[fromHash],
            "From hash is invalid"
        );

        require(
            !currState.hashSet[toHash],
            "To hash is invalid (already exists)"
        );        

        require(
            signerSet[processId][signer],
            "Signer is invalid"
        );

        currState.hashSet[toHash] = true;

        emit ProcessSigned(processId, fromHash, toHash, signer);
    }

    modifier onlyAuthorized {
        require(
            msg.sender == owner,
            "Sender is not authorized"
        );
        _;
    }
}
