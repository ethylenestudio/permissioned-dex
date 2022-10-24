// SPDX-License-Identifier: Unlicensed

pragma solidity >=0.8.4;

struct Auths {
    bool s;
    bool m;
    bool b;
    bool i;
}



/* @notice Standard interface for a permit oracle to be used by a permissioned pool. */
interface ICrocPermitOracle {

    /* @notice Verifies whether a given user is permissioned to perform a swap on the pool
     *
     * @param user The address of the caller to the contract.
     * @param sender The value of msg.sender for the caller of the action. Will either
     *               be same as user, the calling router, or the off-chain relayer.
     * @param base The base-side token in the pair.
     * @param quote The quote-side token in the pair.
     * @param isBuy  If true, the swapper is paying base and receiving quote
     * @param inBaseQty  If true, the qty is denominated in the base token side.
     * @param qty        The full qty on the swap request (could possibly be lower if user
     *                   hits limit price.
     * @param poolFee The effective pool fee set for the swap (either the base fee or the
     *                base fee plus user tip).
     *
     * @returns       If zero, the transaction fails. If non-zero, the user will pay
     *                a swap fee equivalent to @poolFee minus this value. This allows
     *                a permit oracle to disriminate swap fees on a per user basis. (A
     *                value of 1 is economically meaningless at .0001%, and can be used
     *                for the no discount scenario.) */
    function checkApprovedForCrocSwap (address user, address sender,
                                       address base, address quote,
                                       bool isBuy, bool inBaseQty, uint128 qty,
                                       uint16 poolFee)
        external returns (uint16);

    /* @notice Verifies whether a given user is permissioned to mint liquidity
     *         on the pool.
     *
     * @param user The address of the caller to the contract.
     * @param sender The value of msg.sender for the caller of the action. Will either
     *               be same as user, the calling router, or the off-chain relayer.
     * @param base The base-side token in the pair.
     * @param quote The quote-side token in the pair.
     * @param bidTick  The tick index of the lower side of the range (0 if ambient)
     * @param askTick  The tick index of the upper side of the range (0 if ambient)
     * @param liq      The total amount of liquidity being minted. Denominated as
     *                 sqrt(X*Y)
     *
     * @returns       Returns true if action is permitted. If false, CrocSwap will revert
     *                the transaction. */
    function checkApprovedForCrocMint (address user, address sender,
                                       address base, address quote,
                                       int24 bidTick, int24 askTick, uint128 liq)
        external returns (bool);

    /* @notice Verifies whether a given user is permissioned to burn liquidity
     *         on the pool.
     *
     * @param user The address of the caller to the contract.
     * @param sender The value of msg.sender for the caller of the action. Will either
     *               be same as user, the calling router, or the off-chain relayer.
     * @param base The base-side token in the pair.
     * @param quote The quote-side token in the pair.
     * @param bidTick  The tick index of the lower side of the range (0 if ambient)
     * @param askTick  The tick index of the upper side of the range (0 if ambient)
     * @param liq      The total amount of liquidity being minted. Denominated as
     *                 sqrt(X*Y)
     *
     * @returns       Returns true if action is permitted. If false, CrocSwap will revert
     *                the transaction. */
    function checkApprovedForCrocBurn (address user, address sender,
                                       address base, address quote,
                                       int24 bidTick, int24 askTick, uint128 liq)
        external returns (bool);

    /* @notice Verifies whether a given user is permissioned to initialize a pool
     *         attached to this oracle.
     *
     * @param user The address of the caller to the contract.
     * @param sender The value of msg.sender for the caller of the action. Will either
     *               be same as user, the calling router, or the off-chain relayer.
     * @param base The base-side token in the pair.
     * @param quote The quote-side token in the pair.
     * @param poolIdx The Croc-specific pool type index the pool is being created on.
     *
     * @returns       Returns true if action is permitted. If false, CrocSwap will revert
     *                the transaction, and pool will not be initialized. */
    function checkApprovedForCrocInit (address user, address sender,
                                       address base, address quote, uint256 poolIdx)
        external returns (bool);
}