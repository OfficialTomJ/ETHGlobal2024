// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {MockV3Aggregator} from "../src/mocks/MockV3Aggregator.sol";

import {ILink} from "../src/interfaces/chainlink/ILink.sol";

import {Factory} from "../src/RebalancorFactory.sol";

contract FactoryScript is Script {
    Factory factory;
    MockV3Aggregator oracleMockDaiUsd;
    MockV3Aggregator oracleMockWethUsd;

    address constant DAI = 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357;
    address constant WETH = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;

    ILink constant LINK = ILink(0x779877A7B0D9E8603169DdbD7836e478b4624789);

    uint256 constant TOP_UP_AMOUNT = 10e18;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        factory = new Factory();

        oracleMockDaiUsd = new MockV3Aggregator("DAI/USD", 8, 100000000);
        oracleMockWethUsd = new MockV3Aggregator("WETH/USD", 8, 310972000000);

        factory.setMockOracle(DAI, address(oracleMockDaiUsd));
        factory.setMockOracle(WETH, address(oracleMockWethUsd));

        LINK.transfer(address(factory), TOP_UP_AMOUNT);
    }
}
