// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Rebalancor} from "./Rebalancor.sol";

contract Factory {
    mapping(address => address[]) public smartPools;

    function createRebalancor() external {
        address rebalancor = address(new Rebalancor(msg.sender));
        smartPools[msg.sender].push(rebalancor);
    }
}
