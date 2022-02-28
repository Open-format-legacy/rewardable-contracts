// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IMechanism {
    function calculateRewards(uint256) external view returns (uint256);
}
