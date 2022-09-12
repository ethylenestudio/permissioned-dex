// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.9;

import "./ICrocPermitOracle.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

struct Auths {
    bool s;
    bool m;
    bool b;
    bool i;
}

contract CrocPermitOracle is ICrocPermitOracle, Ownable {
    mapping(address => Auths) public auths;

    function batchAuth(address[] memory user, Auths[] memory authList)
        external
        onlyOwner
    {
        for (uint256 i; i < user.length; i++) {
            auths[user[i]] = authList[i];
        }
    }

    function setAuth(address user, Auths memory auth) external onlyOwner {
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
