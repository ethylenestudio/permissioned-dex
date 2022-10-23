// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Hasher {

    function getMessageHash(
        address[] memory _addresses,
        bool _state
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_addresses, _state));
    }

    function getEthSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
            );
    }

    function verifyToAdd(
        address[] memory _signer,
        address[] memory _addresses,
        bytes[] memory signature
    ) public pure returns (bool) {
        uint8 approval = 0;

        for (uint i = 0; i<5;i++){
            bytes32 messageHash = getMessageHash(_addresses, true);
            bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

            if(recoverSigner(ethSignedMessageHash, signature[i]) == _signer[i]){
                approval += 1;
            }
        }

        return approval >= 3;
    }

    function verifyToDelete(
        address[] memory _signer,
        address[] memory _addresses,
        bytes[] memory signature
    ) public pure returns (bool) {
        uint8 approval = 0;

        for (uint i = 0; i<5;i++){
            bytes32 messageHash = getMessageHash(_addresses, false);
            bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

            if(recoverSigner(ethSignedMessageHash, signature[i]) == _signer[i]){
                approval += 1;
            }
        }
        return approval >= 3;
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)
        public
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65, "invalid signature length");
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}

