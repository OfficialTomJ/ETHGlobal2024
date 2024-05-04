export const abi = [
  { inputs: [], stateMutability: "nonpayable", type: "constructor" },
  { inputs: [], name: "UpkeepZero", type: "error" },
  {
    inputs: [
      { internalType: "string", name: "_poolName", type: "string" },
      { internalType: "address[]", name: "_assets", type: "address[]" },
      { internalType: "uint256[]", name: "_weights", type: "uint256[]" },
      { internalType: "uint256", name: "_cadence", type: "uint256" },
    ],
    name: "createRebalancor",
    outputs: [{ internalType: "address", name: "", type: "address" }],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "", type: "address" }],
    name: "smartPoolCount",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "", type: "address" },
      { internalType: "uint256", name: "", type: "uint256" },
    ],
    name: "smartPools",
    outputs: [
      { internalType: "string", name: "name", type: "string" },
      { internalType: "address", name: "rebalancor", type: "address" },
      { internalType: "uint256", name: "upkeepId", type: "uint256" },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;
