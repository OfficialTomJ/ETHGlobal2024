// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {IERC20} from "@oz/token/ERC20/IERC20.sol";

import {Rebalancor} from "../src/Rebalancor.sol";
import {Factory} from "../src/RebalancorFactory.sol";

contract UserFlowScript is Script {
    Rebalancor rebalancor;
    Factory factory;

    address constant DAI = 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357;
    address constant WETH = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        // factory = Factory(0xf5739f3B0B0eFd1A5f8563b1059a70b7a73Ca99e);
        //
        // address[] memory assets = new address[](2);
        // assets[0] = DAI;
        // assets[1] = WETH;
        //
        // uint256[] memory weights = new uint256[](2);
        // weights[0] = 6_000;
        // weights[1] = 4_000;
        //
        // address balancooor = factory.createRebalancor("TEST-ME-NOW", assets, weights, 900);

        rebalancor = Rebalancor(0xd3A1d141753BF91B276f659c561CAbA1AaDDdF6c);

        // IERC20(DAI).approve(address(rebalancor), type(uint256).max);
        // IERC20(WETH).approve(address(rebalancor), type(uint256).max);

        rebalancor.withdrawAll();
    }
}
