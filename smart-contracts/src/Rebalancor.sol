// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@oz/token/ERC20/IERC20.sol";

import {EnumerableSet} from "@oz/utils/structs/EnumerableSet.sol";

contract Rebalancor {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;

    address constant KEEPER_ADDY = address(0);

    ////////////////////////////////////////////////////////////////////////////
    // STORAGE
    ////////////////////////////////////////////////////////////////////////////

    address public poolOwner;

    string public poolName;

    uint256 public cadence;

    uint256 public shift;

    EnumerableSet.UintSet internal weights;

    EnumerableSet.AddressSet internal assets;

    ////////////////////////////////////////////////////////////////////////////
    // ERRORS
    ////////////////////////////////////////////////////////////////////////////

    error NotPoolOwner(address sender);

    constructor(address _poolOwner, string memory _poolName) {
        poolOwner = _poolOwner;

        poolName = _poolName;
    }

    ////////////////////////////////////////////////////////////////////////////
    // MODIFIER
    ////////////////////////////////////////////////////////////////////////////

    modifier onlyPoolOwner() {
        if (msg.sender != poolOwner) revert NotPoolOwner(msg.sender);
        _;
    }

    modifier onlyKeeper() {
        if (msg.sender != KEEPER_ADDY) revert NotPoolOwner(msg.sender);
        _;
    }

    ////////////////////////////////////////////////////////////////////////////
    // EXTERNAL: Portfolio Config
    ////////////////////////////////////////////////////////////////////////////

    function subscribe(address[] memory _assets, uint256[] memory _weights, uint256 _cadence, uint256 _shift)
        external
        onlyPoolOwner
    {
        for (uint256 i = 0; i < _assets.length; i++) {
            assets.add(_assets[i]);
            weights.add(_weights[i]);
        }

        cadence = _cadence;
        shift = _shift;
    }

    function pullAssets() external {
        address[] memory _assets = assets.values();
        for (uint256 i = 0; i < _assets.length; i++) {
            address token = assets.at(i);
            IERC20(token).transferFrom(poolOwner, address(this), IERC20(token).balanceOf(poolOwner));
        }
    }

    function update(uint256[] memory _index, uint256[] memory _weights, uint256 _cadence, uint256 _shift)
        external
        onlyPoolOwner
    {
        for (uint256 i = 0; i < _index.length; i++) {
            weights.set(_index[i], _weights[i]);
        }

        cadence = _cadence;
        shift = _shift;
    }

    function withdrawAll() external onlyPoolOwner {
        address[] memory _assets = assets.values();
        for (uint256 i = 0; i < _assets.length; i++) {
            address token = assets.at(i);
            IERC20(token).transfer(poolOwner, IERC20(token).balanceOf(address(this)));
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    // EXTERNAL: Keeper
    ////////////////////////////////////////////////////////////////////////////

    function rebalance() external onlyKeeper {
        // 1. check if it is time to rebalance
        // 2. if yes, then rebalance
    }

    ////////////////////////////////////////////////////////////////////////////
    // PUBLIC: Reads the portfolio config of an EOA
    ////////////////////////////////////////////////////////////////////////////

    function getPortfolioConfig() external view returns (address[] memory, uint256[] memory) {
        return (assets.values(), weights.values());
    }
}
