// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Rebalancor} from "./Rebalancor.sol";

contract Factory {
    address[] public rebalancors;

    function createRebalancor() external {
        address rebalancor = address(new Rebalancor(msg.sender));
        rebalancors.push(rebalancor);
    }
}
