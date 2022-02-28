// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "./interfaces/IMechanism.sol";

contract Rewardable {
    mapping(address => address) public mechanism;
    using SafeCast for uint256;

    // reward per NFT
    struct RewardPerToken {
        uint256 tokenId; // id of the NFT
        uint256 accumulated; // Accumulated rewards for the user until the checkpoint
        uint32 lastUpdated; // RewardsPerToken the last time the user rewards were updated
    }

    mapping(uint256 => RewardPerToken) public tokenRewards;

    function _setupReward(uint256 _tokenId) internal {
        RewardPerToken memory rewardsPerToken_ = tokenRewards[_tokenId];
        rewardsPerToken_ = RewardPerToken(
            _tokenId,
            0,
            block.timestamp.toUint32()
        );
        tokenRewards[_tokenId] = rewardsPerToken_;
    }

    function _addMechanism(address _rewardToken, address _mechanism) internal {
        mechanism[_rewardToken] = _mechanism;
    }

    function _rewards(address _rewardToken, uint256 _tokenId)
        internal
        view
        returns (uint256)
    {
        require(
            mechanism[_rewardToken] != address(0),
            "Invalid reward or mechanism"
        );
        uint256 amount = IMechanism(mechanism[_rewardToken]).calculateRewards(
            tokenRewards[_tokenId].accumulated
        );
        return amount;
    }

    function _claim(address _rewardToken, uint256 _tokenId)
        internal
        returns (uint256)
    {
        uint256 balance = IERC20(_rewardToken).balanceOf(address(this));
        uint256 accumulated = tokenRewards[_tokenId].accumulated;

        require(balance > accumulated, "Not enough tokens in contract");

        _updateRewards(_tokenId, _rewardToken);
        IERC20(_rewardToken).transfer(msg.sender, accumulated);

        return accumulated;
    }

    function _updateRewards(uint256 _tokenId, address _rewardToken)
        private
        returns (uint256)
    {
        require(
            mechanism[_rewardToken] != address(0),
            "Invalid reward token or mechanism"
        );
        uint256 amount = IMechanism(mechanism[_rewardToken]).calculateRewards(
            tokenRewards[_tokenId].accumulated
        );
        return tokenRewards[_tokenId].accumulated += amount;
    }
}
