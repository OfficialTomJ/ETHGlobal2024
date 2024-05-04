// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "@oz/token/ERC20/IERC20.sol";

import {EnumerableSet} from "@oz/utils/structs/EnumerableSet.sol";

import {IAggregatorV3} from "./interfaces/chainlink/IAggregatorV3.sol";
import {KeeperCompatibleInterface} from "./interfaces/chainlink/KeeperCompatibleInterface.sol";

import {IRouterV2} from "./interfaces/uniswap/IRouterV2.sol";

import {IRebalancorFactory} from "./interfaces/IRebalancorFactory.sol";

contract Rebalancor is KeeperCompatibleInterface {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;

    ////////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ////////////////////////////////////////////////////////////////////////////

    uint256 constant MAX_BPS = 10_000;
    uint256 constant DEVIATION_THRESHOLD = 1_000; // 10%

    address constant WBTC = 0x29f2D40B0605204364af54EC677bD022dA425d03;
    address constant LINK = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
    address constant DAI = 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357;
    address constant WETH = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;

    IRouterV2 constant AMM = IRouterV2(payable(0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008));

    // automation registry
    address constant REGISTRY_CL = 0x86EFBD0b6736Bed994962f9797049422A3A8E8Ad;

    // feeds
    address constant CL_BTC_USD = 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43;
    address constant CL_ETH_USD = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address constant CL_LINK_USD = 0x42585eD362B3f1BCa95c640FdFf35Ef899212734;
    address constant CL_DAI_USD = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;

    ////////////////////////////////////////////////////////////////////////////
    // STORAGE
    ////////////////////////////////////////////////////////////////////////////

    address public poolOwner;

    IRebalancorFactory public factory;

    string public poolName;

    uint256 public cadence;
    uint256 public lastRebalance;

    EnumerableSet.UintSet internal weights;

    EnumerableSet.AddressSet internal assets;

    mapping(address => address) public assetToOracle;

    ////////////////////////////////////////////////////////////////////////////
    // ERRORS
    ////////////////////////////////////////////////////////////////////////////

    error NotSameLength();

    error NotPoolOwner(address caller);
    error NotClRegistry(address caller);

    error StaleFeed(uint256 currentTime, uint256 updateTime, uint256 maxPeriod);
    error NegativeAnswer(address feed, int256 answer, uint256 timestamp);

    constructor(
        address _poolOwner,
        string memory _poolName,
        address[] memory _assets,
        uint256[] memory _weights,
        uint256 _cadence,
        address _factory
    ) {
        poolOwner = _poolOwner;

        poolName = _poolName;

        factory = IRebalancorFactory(_factory);

        _subscribe(_assets, _weights, _cadence);
    }

    ////////////////////////////////////////////////////////////////////////////
    // MODIFIER
    ////////////////////////////////////////////////////////////////////////////

    modifier onlyPoolOwner() {
        if (msg.sender != poolOwner) revert NotPoolOwner(msg.sender);
        _;
    }

    modifier onlyKeeper() {
        if (msg.sender != REGISTRY_CL) revert NotClRegistry(msg.sender);
        _;
    }

    ////////////////////////////////////////////////////////////////////////////
    // EXTERNAL: Portfolio Config
    ////////////////////////////////////////////////////////////////////////////

    /// @param _assets The list of assets to subscribe to.
    /// @param _weights The list of weights for each asset.
    /// @param _cadence The time between rebalances.
    function _subscribe(address[] memory _assets, uint256[] memory _weights, uint256 _cadence) internal {
        if (_assets.length != _weights.length) revert NotSameLength();

        for (uint256 i = 0; i < _assets.length; i++) {
            assets.add(_assets[i]);
            weights.add(_weights[i]);
            IERC20(_assets[i]).approve(address(AMM), type(uint256).max);
        }

        cadence = _cadence;
    }

    function pullAssets() external {
        address[] memory _assets = assets.values();
        for (uint256 i = 0; i < _assets.length; i++) {
            address token = assets.at(i);
            IERC20(token).transferFrom(poolOwner, address(this), IERC20(token).balanceOf(poolOwner));
        }
    }

    function update(uint256[] memory _index, uint256[] memory _weights, uint256 _cadence) external onlyPoolOwner {
        for (uint256 i = 0; i < _index.length; i++) {
            uint256 w = _weights[i];
            // weights.set(_index[i], _weights[i]);
        }

        cadence = _cadence;
    }

    function withdrawAll() external onlyPoolOwner {
        address[] memory _assets = assets.values();
        for (uint256 i = 0; i < _assets.length; i++) {
            address token = assets.at(i);
            IERC20(token).transfer(poolOwner, IERC20(token).balanceOf(address(this)));
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    // VIEW
    ////////////////////////////////////////////////////////////////////////////

    function checkUpKeepInteligence() internal view returns (bool[] memory, uint256[] memory) {
        return _checkUpKeepInteligence();
    }

    ////////////////////////////////////////////////////////////////////////////
    // EXTERNAL: Keeper
    ////////////////////////////////////////////////////////////////////////////

    function checkUpkeep(bytes calldata)
        external
        view
        override
        returns (bool upkeepNeeded_, bytes memory performData_)
    {
        // @note any logic for rebalancing could be implemented here
        (bool[] memory isRebalanceRequired, uint256[] memory rebalanceAmounts) = _checkUpKeepInteligence();

        return (lastRebalance + cadence >= block.timestamp, abi.encode(isRebalanceRequired, rebalanceAmounts));
    }

    function _checkUpKeepInteligence() internal view returns (bool[] memory, uint256[] memory) {
        address[] memory _assets = assets.values();
        uint256[] memory _cachedPrices = new uint256[](_assets.length);
        uint256[] memory _cachedBalances = new uint256[](_assets.length);

        uint256 totalUsd;
        for (uint256 i = 0; i < _assets.length; i++) {
            address token = assets.at(i);
            uint256 price = _fetchPriceFeed(factory.getMockOracle(token), 2 hours);
            _cachedPrices[i] = price;
            uint256 balance = IERC20(token).balanceOf(address(this));
            _cachedBalances[i] = balance;
            totalUsd += balance * price;
        }

        uint256[] memory _weights = weights.values();
        uint256[] memory _currentWeights = new uint256[](_weights.length);
        bool[] memory _rebalanceIsRequired = new bool[](_weights.length);
        uint256[] memory _rebalanceAmounts = new uint256[](_weights.length);
        for (uint256 i = 0; i < _weights.length; i++) {
            _currentWeights[i] = (_cachedBalances[i] * _cachedPrices[i] * 1e18) / totalUsd;
            if (_currentWeights[i] > _weights[i] + DEVIATION_THRESHOLD) {
                // @note it is over weight, take profit!
                _rebalanceIsRequired[i] = true;
                _rebalanceAmounts[i] = (_cachedBalances[i] * DEVIATION_THRESHOLD) / MAX_BPS;
            } else if (_currentWeights[i] < _weights[i] - DEVIATION_THRESHOLD) {
                // @note it is under weight, stop loss!
                _rebalanceIsRequired[i] = true;
                _rebalanceAmounts[i] = (_cachedBalances[i] * DEVIATION_THRESHOLD) / MAX_BPS;
            }
        }

        return (_rebalanceIsRequired, _rebalanceAmounts);
    }

    function performUpkeep(bytes calldata _performData) external override onlyKeeper {
        (bool[] memory isRebalanceRequired, uint256[] memory rebalanceAmounts) =
            abi.decode(_performData, (bool[], uint256[]));

        address[] memory _assets = assets.values();
        for (uint256 i = 0; i < _assets.length; i++) {
            if (isRebalanceRequired[i]) {
                // @note simple swap for LINK for now
                address token = assets.at(i);
                address[] memory path = new address[](2);
                path[0] = token;
                path[1] = LINK;
                AMM.swapTokensForExactTokens(rebalanceAmounts[i], 0, path, address(this), block.timestamp);
            }
        }

        lastRebalance = block.timestamp;
    }

    ////////////////////////////////////////////////////////////////////////////
    // PUBLIC: Reads the portfolio config of an EOA
    ////////////////////////////////////////////////////////////////////////////

    function getPortfolioConfig() external view returns (address[] memory, uint256[] memory) {
        return (assets.values(), weights.values());
    }

    ////////////////////////////////////////////////////////////////////////////
    // INTERNAL
    ////////////////////////////////////////////////////////////////////////////

    function _fetchPriceFeed(address _feed, uint256 _maxStalePeriod) internal view returns (uint256 answer_) {
        (, int256 answer,, uint256 updateTime,) = IAggregatorV3(_feed).latestRoundData();

        if (answer < 0) revert NegativeAnswer(_feed, answer, block.timestamp);
        if (block.timestamp - updateTime > _maxStalePeriod) {
            revert StaleFeed(block.timestamp, updateTime, _maxStalePeriod);
        }

        answer_ = uint256(answer);
    }
}
