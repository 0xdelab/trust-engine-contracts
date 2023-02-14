// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract AuditTrail {

    address private owner;

    event Breadcrumb(bytes32 signer, string metadata);

    constructor() {
        owner = msg.sender;
    }

    function record(
        bytes32 signer,
        string calldata metadata
    ) public onlyAuthorized {

        emit Breadcrumb(signer, metadata);
    }

    modifier onlyAuthorized {
        require(
            msg.sender == owner,
            "Sender is not authorized"
        );
        _;
    }
}
