// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {Rebalancor} from "../src/Rebalancor.sol";

contract RebalancorScript is Script {
    Rebalancor rebalancor;

    address constant LINK = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
    address constant DAI = 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        address[] memory tokens = new address[](2);
        tokens[0] = DAI;
        tokens[1] = LINK;

        uint256[] memory weights = new uint256[](2);
        weights[0] = 6_000;
        weights[1] = 4_000;

        rebalancor = new Rebalancor(
            deployer,
            "DUMMY-PLACER-FOR-VERIFICATIONS",
            tokens,
            weights,
            1 hours,
            address(0x63E5B6398A1779CF5620580b26296BE42FF46080)
        );
    }
}
