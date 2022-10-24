// SPDX-License-Identifier: No License (None)
pragma solidity ^0.8.17;

/**
 * EIP-712 typehashes library for CrocSwap
 */
library TypeHashes {
    // Domain data
    string constant name = "CrocSwap";
    string constant version = "1";
    uint256 constant chainID = 31337;

    // Domain typehash
    bytes32 constant EIP712DOMAIN_TYPEHASH =
        keccak256(
            "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
        );

    // Domain typehash
    bytes32 constant SETAUTH_TYPEHASH =
        keccak256(
            "setAuth(address user,bool s,bool m,bool b,bool i)"
        );



        // Domain typehash
    bytes32 constant SETBATCHAUTH_TYPEHASH =
        keccak256(
            "setBatchAuth(bytes32 root)"
        );

}