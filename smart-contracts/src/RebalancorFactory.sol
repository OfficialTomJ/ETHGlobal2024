// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Rebalancor} from "./Rebalancor.sol";

contract Factory {
    ////////////////////////////////////////////////////////////////////////////
    // STORAGE
    ////////////////////////////////////////////////////////////////////////////

    // eoa -> smart pools
    mapping(address => address[]) public smartPools;

    /// @param _poolName The name of the pool
    function createRebalancor(string memory _poolName) external returns (address) {
        address rebalancor = address(new Rebalancor(msg.sender, _poolName));
        smartPools[msg.sender].push(rebalancor);
        return rebalancor;
    }
}
