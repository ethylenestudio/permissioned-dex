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

    // function batchAuth(
    //     address[] memory signers,
    //     uint8[] memory vs,
    //     bytes32[] memory rs,
    //     bytes32[] memory ss,
    //     address[] memory user,
    //     Auths[] memory authList
    // )
    //     external

    // {
    //     require(keccak256(abi.encodePacked(signers)) == ownersHash);

    //     for (uint256 i; i < user.length; i++) {
    //         auths[user[i]] = authList[i];

    //     require(verify(signers, user, auth, vs, rs, ss), "Not auth!");
    //     auths[user] = auth;
    //     }
    // }

    function setAuth(
        address[] memory signers,
        uint8[] memory vs,
        bytes32[] memory rs,
        bytes32[] memory ss,
        address user,
        Auths memory auth
    )
        external
    {
        require(keccak256(abi.encodePacked(signers)) == ownersHash);
        require(verifyAuth(signers, user, auth, vs, rs, ss), "Not auth!");

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

/** can be used for bool storing

    function getBoolean(uint256 _packedBools, uint256 _boolNumber)
        public view returns(bool)
    {
        uint256 flag = (_packedBools >> _boolNumber) & uint256(1);
        return (flag == 1 ? true : false);
    }


    function setBoolean(
        uint256 _packedBools,
        uint256 _boolNumber,
        bool _value
    ) public returns(uint256) {
        if (_value)
            _packedBools = _packedBools | uint256(1) << _boolNumber;
            return _packedBools;
        else
            _packedBools = _packedBools & ~(uint256(1) << _boolNumber);
            return _packedBools;
    }

 */
