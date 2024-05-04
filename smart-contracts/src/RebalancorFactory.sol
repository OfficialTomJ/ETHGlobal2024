// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IKeeperRegistry} from "./interfaces/chainlink/IKeeperRegistry.sol";
import {IKeeperRegistrar} from "./interfaces/chainlink/IKeeperRegistrar.sol";
import {ILink} from "./interfaces/chainlink/ILink.sol";

import {Rebalancor} from "./Rebalancor.sol";

contract Factory {
    struct SmartPoolInfo {
        string name;
        address rebalancor;
        uint256 upkeepId;
    }

    ////////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ////////////////////////////////////////////////////////////////////////////

    IKeeperRegistrar constant CL_REGISTRAR = IKeeperRegistrar(0xb0E49c5D0d05cbc241d68c05BC5BA1d1B7B72976);
    IKeeperRegistry constant CL_REGISTRY = IKeeperRegistry(0x86EFBD0b6736Bed994962f9797049422A3A8E8Ad);
    ILink constant LINK = ILink(0x779877A7B0D9E8603169DdbD7836e478b4624789);

    ////////////////////////////////////////////////////////////////////////////
    // STORAGE
    ////////////////////////////////////////////////////////////////////////////

    // eoa -> smart pools
    mapping(address => SmartPoolInfo[]) public smartPools;

    // eoa -> smart pool count deployed
    mapping(address => uint256) public smartPoolCount;

    error UpkeepZero();

    constructor() {
        LINK.approve(address(CL_REGISTRAR), type(uint256).max);
    }

    ////////////////////////////////////////////////////////////////////////////
    // EXTERNAL: SMART POOL CREATOR FUNCTION
    ////////////////////////////////////////////////////////////////////////////

    /// @param _poolName The name of the pool
    function createRebalancor(string memory _poolName) external returns (address) {
        address rebalancor = address(new Rebalancor(msg.sender, _poolName));

        uint256 upkeepId = _registerSmartPoolUpkeep(_poolName, rebalancor);

        smartPools[msg.sender].push(SmartPoolInfo({name: _poolName, rebalancor: rebalancor, upkeepId: upkeepId}));
        smartPoolCount[msg.sender] += 1;

        return rebalancor;
    }

    ////////////////////////////////////////////////////////////////////////////
    // INTERNAL
    ////////////////////////////////////////////////////////////////////////////

    /// @param _rebalancor The address of the rebalancor to be register in the automation registry
    function _registerSmartPoolUpkeep(string memory _poolName, address _rebalancor)
        internal
        returns (uint256 upkeepID_)
    {
        IKeeperRegistrar.RegistrationParams memory registrationParams = IKeeperRegistrar.RegistrationParams({
            name: _poolName,
            encryptedEmail: "",
            upkeepContract: _rebalancor,
            gasLimit: 2_000_000,
            adminAddress: msg.sender,
            triggerType: 0,
            checkData: "",
            triggerConfig: "",
            offchainConfig: "",
            amount: 10e18
        });

        upkeepID_ = CL_REGISTRAR.registerUpkeep(registrationParams);

        if (upkeepID_ == 0) revert UpkeepZero();
    }
}
