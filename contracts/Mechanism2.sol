// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Mechanism2 is Ownable {
    uint256 public rewardRate;

    event RewardRateSet(uint256);

    constructor(uint256 _rewardRate){
        require(_rewardRate > 0, "Reward rate can't be 0");
        rewardRate = _rewardRate;
    }

    function setRewardRate(uint256 _amount) public onlyOwner {
        rewardRate = _amount;

        emit RewardRateSet(_amount);
    }

    function calculateRewards(uint256 _currentRewards) external view returns (uint256) {
        return rewardRate * 10 + _currentRewards;
    }
}
