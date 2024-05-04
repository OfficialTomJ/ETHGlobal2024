// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IKeeperRegistry {
    event AdminPrivilegeConfigSet(address indexed admin, bytes privilegeConfig);
    event CancelledUpkeepReport(uint256 indexed id, bytes trigger);
    event ConfigSet(
        uint32 previousConfigBlockNumber,
        bytes32 configDigest,
        uint64 configCount,
        address[] signers,
        address[] transmitters,
        uint8 f,
        bytes onchainConfig,
        uint64 offchainConfigVersion,
        bytes offchainConfig
    );
    event DedupKeyAdded(bytes32 indexed dedupKey);
    event FundsAdded(uint256 indexed id, address indexed from, uint96 amount);
    event FundsWithdrawn(uint256 indexed id, uint256 amount, address to);
    event InsufficientFundsUpkeepReport(uint256 indexed id, bytes trigger);
    event OwnerFundsWithdrawn(uint96 amount);
    event OwnershipTransferRequested(address indexed from, address indexed to);
    event OwnershipTransferred(address indexed from, address indexed to);
    event Paused(address account);
    event PayeesUpdated(address[] transmitters, address[] payees);
    event PayeeshipTransferRequested(address indexed transmitter, address indexed from, address indexed to);
    event PayeeshipTransferred(address indexed transmitter, address indexed from, address indexed to);
    event PaymentWithdrawn(address indexed transmitter, uint256 indexed amount, address indexed to, address payee);
    event ReorgedUpkeepReport(uint256 indexed id, bytes trigger);
    event StaleUpkeepReport(uint256 indexed id, bytes trigger);
    event Transmitted(bytes32 configDigest, uint32 epoch);
    event Unpaused(address account);
    event UpkeepAdminTransferRequested(uint256 indexed id, address indexed from, address indexed to);
    event UpkeepAdminTransferred(uint256 indexed id, address indexed from, address indexed to);
    event UpkeepCanceled(uint256 indexed id, uint64 indexed atBlockHeight);
    event UpkeepCheckDataSet(uint256 indexed id, bytes newCheckData);
    event UpkeepGasLimitSet(uint256 indexed id, uint96 gasLimit);
    event UpkeepMigrated(uint256 indexed id, uint256 remainingBalance, address destination);
    event UpkeepOffchainConfigSet(uint256 indexed id, bytes offchainConfig);
    event UpkeepPaused(uint256 indexed id);
    event UpkeepPerformed(
        uint256 indexed id,
        bool indexed success,
        uint96 totalPayment,
        uint256 gasUsed,
        uint256 gasOverhead,
        bytes trigger
    );
    event UpkeepPrivilegeConfigSet(uint256 indexed id, bytes privilegeConfig);
    event UpkeepReceived(uint256 indexed id, uint256 startingBalance, address importedFrom);
    event UpkeepRegistered(uint256 indexed id, uint32 performGas, address admin);
    event UpkeepTriggerConfigSet(uint256 indexed id, bytes triggerConfig);
    event UpkeepUnpaused(uint256 indexed id);

    fallback() external;

    function acceptOwnership() external;

    function fallbackTo() external view returns (address);

    function latestConfigDetails()
        external
        view
        returns (uint32 configCount, uint32 blockNumber, bytes32 configDigest);

    function latestConfigDigestAndEpoch() external view returns (bool scanLogs, bytes32 configDigest, uint32 epoch);

    function onTokenTransfer(address sender, uint256 amount, bytes memory data) external;

    function owner() external view returns (address);

    function setConfig(
        address[] memory signers,
        address[] memory transmitters,
        uint8 f,
        bytes memory onchainConfigBytes,
        uint64 offchainConfigVersion,
        bytes memory offchainConfig
    ) external;

    function setConfigTypeSafe(
        address[] memory signers,
        address[] memory transmitters,
        uint8 f,
        KeeperRegistryBase2_1.OnchainConfig memory onchainConfig,
        uint64 offchainConfigVersion,
        bytes memory offchainConfig
    ) external;

    function simulatePerformUpkeep(uint256 id, bytes memory performData)
        external
        returns (bool success, uint256 gasUsed);

    function transferOwnership(address to) external;

    function transmit(
        bytes32[3] memory reportContext,
        bytes memory rawReport,
        bytes32[] memory rs,
        bytes32[] memory ss,
        bytes32 rawVs
    ) external;

    function typeAndVersion() external view returns (string memory);
}

interface KeeperRegistryBase2_1 {
    struct OnchainConfig {
        uint32 paymentPremiumPPB;
        uint32 flatFeeMicroLink;
        uint32 checkGasLimit;
        uint24 stalenessSeconds;
        uint16 gasCeilingMultiplier;
        uint96 minUpkeepSpend;
        uint32 maxPerformGas;
        uint32 maxCheckDataSize;
        uint32 maxPerformDataSize;
        uint32 maxRevertDataSize;
        uint256 fallbackGasPrice;
        uint256 fallbackLinkPrice;
        address transcoder;
        address[] registrars;
        address upkeepPrivilegeManager;
    }
}
