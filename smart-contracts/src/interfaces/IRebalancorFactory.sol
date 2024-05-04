// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IRebalancorFactory {
    function getMockOracle(address _asset) external view returns (address);
}
