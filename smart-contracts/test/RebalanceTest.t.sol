// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {console} from "forge-std/Test.sol";

import {BaseFixture} from "./BaseFixture.sol";

import {IERC20} from "@oz/token/ERC20/IERC20.sol";

contract RebalanceTest is BaseFixture {
    function test_rebalance() public {
        vm.prank(DEPLOYER);
        IERC20(DAI).approve(address(rebalancor), type(uint256).max);
        vm.prank(DEPLOYER);
        IERC20(WETH).approve(address(rebalancor), type(uint256).max);

        vm.prank(DEPLOYER);
        rebalancor.pullAssets();

        assertGt(IERC20(DAI).balanceOf(address(rebalancor)), 0);
        assertGt(IERC20(WETH).balanceOf(address(rebalancor)), 0);

        (bool upkeepNeeded_, bytes memory performData_) = rebalancor.checkUpkeep("");
        assertFalse(upkeepNeeded_);

        skip(6 minutes);
        oracleMockWethUsd.updateAnswer(450972000000);

        (upkeepNeeded_, performData_) = rebalancor.checkUpkeep("");
        assertTrue(upkeepNeeded_);

        uint256 prevWethBalance = IERC20(WETH).balanceOf(address(rebalancor));
        uint256 prevDaiBalance = IERC20(DAI).balanceOf(address(rebalancor));

        (bool[] memory rebalanceIsRequired, uint256[] memory rebalanceAmounts) = rebalancor.checkUpKeepInteligence();
        console.log(rebalanceAmounts[0]);
        console.log(rebalanceAmounts[1]);

        vm.prank(CL_REGISTRY);
        rebalancor.performUpkeep(performData_);
    }
}
