// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {Rebalancor} from "../src/Rebalancor.sol";

contract RebalancorScript is Script {
    Rebalancor rebalancor;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        rebalancor = new Rebalancor(deployer, "DUMMY-PLACER-FOR-VERIFICATIONS");
    }
}
