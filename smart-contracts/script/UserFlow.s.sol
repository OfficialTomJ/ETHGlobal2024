// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {IERC20} from "@oz/token/ERC20/IERC20.sol";

import {Rebalancor} from "../src/Rebalancor.sol";

contract UserFlowScript is Script {
    Rebalancor rebalancor;

    address constant DAI = 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357;
    address constant WETH = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        rebalancor = Rebalancor(0x0e50e601551fB470F860A694EFBb9CB3f11d49E1);

        IERC20(DAI).approve(address(rebalancor), type(uint256).max);
        IERC20(WETH).approve(address(rebalancor), type(uint256).max);

        rebalancor.pullAssets();
    }
}
