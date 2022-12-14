// SPDX-License-Identifier: No License (None)
pragma solidity ^0.8.17;

import "./utils/TypeHashes.sol";
import "./interfaces/ICrocPermitOracle.sol";

struct EIP712Domain {
    string name; // App name
    string version; // App version
    uint256 chainId; // Chain id
    address verifyingContract; // Verifier contract of the signs
}

/**
 * @notice Abstract contract to be used in Marketplace contract as EIP-712 helper
 */
abstract contract Hasher {
    // EIP-712 domain seperator
    bytes32 internal immutable DOMAIN_SEPARATOR;

    /**
     * @notice Constructor function for the contract, calculates domain seperator
     */
    constructor() {
        DOMAIN_SEPARATOR = hash(
            EIP712Domain(
                TypeHashes.name,
                TypeHashes.version,
                TypeHashes.chainID,
                address(this)
            )
        );
    }

    /**
     * @notice Internal hashing helper for verifying
     */
    function hash(EIP712Domain memory _eip712Domain)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encode(
                    TypeHashes.EIP712DOMAIN_TYPEHASH,
                    keccak256(bytes(_eip712Domain.name)),
                    keccak256(bytes(_eip712Domain.version)),
                    _eip712Domain.chainId,
                    _eip712Domain.verifyingContract
                )
            );
    }

    /**
     * @dev Internal hashing helper for verifying
     */
    function hashAuth(address _user, Auths memory _auths)
        public
        pure
        returns (bytes32)
    {
        return (
            keccak256(
                abi.encode(
                    TypeHashes.SETAUTH_TYPEHASH,
                    _user,
                    _auths.s,
                    _auths.m,
                    _auths.b,
                    _auths.i
                )
            )
        );
    }



    /**
     * @notice Internal verifier for data - signtures
     */
    function verifyAuth(
        address user,
        Auths memory auths,
        address[] memory signers,
        uint8[] memory vs,
        bytes32[] memory rs,
        bytes32[] memory ss
    ) public view returns (bool) {
        uint8 approvalCount;
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                hashAuth(user, auths)
            )
        );

        for (uint256 i = 0; i < signers.length; i++) {
            if (ecrecover(digest, vs[i], rs[i], ss[i]) == signers[i])
                approvalCount++;
        }

        return approvalCount >= 3;
    }

    /**
     * @dev Internal hashing helper for verifying
     */
    function hashBatchAuth(
        bytes32 root
    ) public pure returns (bytes32) {
        return (
            keccak256(
                abi.encode(TypeHashes.SETBATCHAUTH_TYPEHASH, root)
            )
        );
    }

    /**
     * @notice Internal verifier for data - signtures
     */
    function verifyBatchAuth(
        bytes32 root,
        address[] memory signers,
        uint8[] memory vs,
        bytes32[] memory rs,
        bytes32[] memory ss
    ) public view returns (bool) {
        uint8 approvalCount;

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                hashBatchAuth(root)
            )
        );

        for (uint8 i = 0; i < signers.length; i++) {
            if (ecrecover(digest, vs[i], rs[i], ss[i]) == signers[i])
                approvalCount++;
        }

        return approvalCount >= 3;
    }
}
