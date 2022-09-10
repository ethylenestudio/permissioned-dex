// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CrocPermitOracle is Ownable {
    // swap - mint - burn - init
    mapping(address => bool[4]) public auths;

    function setAuth(address user, bool[4] memory userAuths)
        external
        onlyOwner
    {
        auths[user] = userAuths;
    }

    function checkApprovedForCrocSwap(
        address user,
        address,
        address,
        address,
        bool,
        bool,
        uint128,
        uint16
    ) external view returns (uint16) {
        return auths[user][0] ? uint16(1) : uint16(0);
    }

    function checkApprovedForCrocMint(
        address user,
        address,
        address,
        address,
        int256,
        int256,
        uint16
    ) external view returns (bool) {
        return auths[user][1];
    }

    function checkApprovedForCrocBurn(
        address user,
        address,
        address,
        address,
        int256,
        int256,
        uint16
    ) external view returns (bool) {
        return auths[user][2];
    }

    function checkApprovedForCrocInit(
        address user,
        address,
        address,
        address,
        uint256
    ) external view returns (bool) {
        return auths[user][3];
    }
}
