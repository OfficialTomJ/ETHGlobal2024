// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {Rebalancor} from "../src/Rebalancor.sol";

contract TriggerUpkeepScript is Script {
    Rebalancor rebalancor;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        rebalancor = Rebalancor(0xd3A1d141753BF91B276f659c561CAbA1AaDDdF6c);

        (bool upkeepNeeded_, bytes memory performData_) = rebalancor.checkUpkeep("");

        // check up outputs
        console.log(upkeepNeeded_);
        console.logBytes(performData_);
        console.log("========================================================");

        (bool[] memory isReq, uint256[] memory rebalAmt) = rebalancor.checkUpKeepInteligence();

        console.log(isReq[0]);
        console.log(isReq[1]);
        console.log(rebalAmt[0]);
        console.log(rebalAmt[1]);
        console.log("========================================================");

        console.log(rebalancor.cadence());
        console.log(rebalancor.lastRebalance());

        if (upkeepNeeded_) {
            rebalancor.performUpkeep(performData_);
        }
    }
}
