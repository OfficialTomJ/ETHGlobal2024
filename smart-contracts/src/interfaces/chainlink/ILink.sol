// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ILink {
    function approve(address _spender, uint256 _value) external returns (bool);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferAndCall(address _to, uint256 _value, bytes memory _data) external returns (bool success);

    function balanceOf(address account) external view returns (uint256);
}
