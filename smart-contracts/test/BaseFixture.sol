// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import {MockV3Aggregator} from "../src/mocks/MockV3Aggregator.sol";

import {ILink} from "../src/interfaces/chainlink/ILink.sol";

import {Factory} from "../src/RebalancorFactory.sol";
import {Rebalancor} from "../src/Rebalancor.sol";

contract BaseFixture is Test {
    Rebalancor rebalancor;
    Factory factory;
    MockV3Aggregator oracleMockDaiUsd;
    MockV3Aggregator oracleMockWethUsd;

    address constant DEPLOYER = 0xcB1c77846c34Ea44F40B447FaE0D2FdF2b4b5919;

    address constant DAI = 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357;
    address constant WETH = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;

    ILink constant LINK = ILink(0x779877A7B0D9E8603169DdbD7836e478b4624789);

    address constant CL_REGISTRAR = 0xb0E49c5D0d05cbc241d68c05BC5BA1d1B7B72976;
    address constant CL_REGISTRY = 0x86EFBD0b6736Bed994962f9797049422A3A8E8Ad;

    uint256 constant TOP_UP_AMOUNT = 10e18;

    address constant AMM = 0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008;

    function setUp() public {
        vm.createSelectFork("sepolia", 5833416);

        factory = new Factory();

        oracleMockDaiUsd = new MockV3Aggregator("DAI/USD", 8, 100000000);
        oracleMockWethUsd = new MockV3Aggregator("WETH/USD", 8, 310972000000);

        factory.setMockOracle(DAI, address(oracleMockDaiUsd));
        factory.setMockOracle(WETH, address(oracleMockWethUsd));

        address[] memory assets = new address[](2);
        assets[0] = DAI;
        assets[1] = WETH;

        uint256[] memory weights = new uint256[](2);
        weights[0] = 5_000;
        weights[1] = 5_000;

        vm.prank(DEPLOYER);
        LINK.transfer(address(factory), TOP_UP_AMOUNT);

        vm.prank(DEPLOYER);
        address rebalancorAddress = factory.createRebalancor("test", assets, weights, 300);

        rebalancor = Rebalancor(rebalancorAddress);

        vm.label(address(factory), "FACTORY");
        vm.label(rebalancorAddress, "REBALANCOR");
        vm.label(WETH, "WETH");
        vm.label(DAI, "DAI");
        vm.label(address(LINK), "LINK");
        vm.label(CL_REGISTRAR, "CL_REGISTRAR");
        vm.label(CL_REGISTRY, "CL_REGISTRY");
        vm.label(AMM, "AMM");
    }
}
