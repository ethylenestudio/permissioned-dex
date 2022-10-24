// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Hasher712.sol";
import "./utils/TypeHashes.sol";
import "./interfaces/ICrocPermitOracle.sol";

contract CrocPermitOracle is ICrocPermitOracle, Hasher{
    mapping(address => Auths) public auths;
    bytes32 public ownersHash;

    constructor(address[5] memory _owners) {
        ownersHash = keccak256(abi.encodePacked(_owners));
    }

    function batchAuth(
        address[] memory users,
        Auths[] memory authList,
        address[] memory signers,
        uint8[] memory vs,
        bytes32[] memory rs,
        bytes32[] memory ss
    )
        external

    {
        require(keccak256(abi.encodePacked(signers)) == ownersHash);
        bytes32 root = keccak256(abi.encode(users,authList));
        require(verifyBatchAuth(root, signers, vs, rs, ss), "Not auth!");


        for (uint256 i; i < users.length; i++) {
            auths[users[i]] = authList[i];
        }
    }

    function setAuth(
        address user,
        Auths memory auth,
        address[] memory signers,
        uint8[] memory vs,
        bytes32[] memory rs,
        bytes32[] memory ss
    )
        external
    {
        require(keccak256(abi.encodePacked(signers)) == ownersHash);
        require(verifyAuth( user, auth,signers, vs, rs, ss), "Not auth!");

        auths[user] = auth;
    }

    function checkApprovedForCrocSwap(
        address user,
        address sender,
        address base,
        address quote,
        bool isBuy,
        bool inBaseQty,
        uint128 qty,
        uint16 poolFee
    ) external view override returns (uint16) {
        return auths[user].s ? uint16(1) : uint16(0);
    }

    function checkApprovedForCrocMint(
        address user,
        address sender,
        address base,
        address quote,
        int24 bidTick,
        int24 askTick,
        uint128 liq
    ) external view override returns (bool) {
        return auths[user].m;
    }

    function checkApprovedForCrocBurn(
        address user,
        address sender,
        address base,
        address quote,
        int24 bidTick,
        int24 askTick,
        uint128 liq
    ) external view override returns (bool) {
        return auths[user].b;
    }

    function checkApprovedForCrocInit(
        address user,
        address sender,
        address base,
        address quote,
        uint256 poolIdx
    ) external view override returns (bool) {
        return auths[user].i;
    }
}
