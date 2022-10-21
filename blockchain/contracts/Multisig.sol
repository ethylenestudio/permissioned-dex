// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Hasher.sol";

contract VerifySignature is Hasher {
    bytes32 public ownersHash;

    mapping(address => bool) public whitelist;

    constructor(address[5] memory _owners) {
        ownersHash = keccak256(abi.encodePacked(_owners));
    }

    function addToWhitelist(
        address[] memory _signers,
        address[] memory _addresses,
        bytes[] memory signatures
    ) public returns (bool) {
        require(verifyToAdd(_signers, _addresses, signatures), "Not signed!");
        require(keccak256(abi.encodePacked(_signers)) == ownersHash);

        for (uint256 i = 0; i < _addresses.length; i++) {
            if (whitelist[_addresses[i]] == true) {
                continue;
            }
            whitelist[_addresses[i]] = true;
        }
        return true;
    }

    function deleteFromWhitelist(
        address[] memory _signers,
        address[] memory _addresses,
        bytes[] memory signatures
    ) public returns (bool) {
        require(verifyToDelete(_signers, _addresses, signatures), "Not signed!");
        require(keccak256(abi.encodePacked(_signers)) == ownersHash);

        for (uint256 i = 0; i < _addresses.length; i++) {
            if (whitelist[_addresses[i]] == false) {
                continue;
            }
            whitelist[_addresses[i]] = false;
        }
        return true;
    }
}
