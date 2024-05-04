// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {ILink} from "../src/interfaces/chainlink/ILink.sol";

import {Factory} from "../src/RebalancorFactory.sol";

contract FactoryScript is Script {
    Factory factory;

    ILink constant LINK = ILink(0x779877A7B0D9E8603169DdbD7836e478b4624789);

    uint256 constant TOP_UP_AMOUNT = 100e18;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        factory = new Factory();

        LINK.transfer(address(factory), TOP_UP_AMOUNT);
    }
}
