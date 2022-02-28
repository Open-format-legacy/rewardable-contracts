// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Rewardable.sol";

contract NFT is ERC721, Rewardable, ERC721Enumerable, Ownable {
    constructor() ERC721("MyToken", "MTK") {}

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = totalSupply();
        _safeMint(to, tokenId);
        _setupReward(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function addMechanism(address _rewardToken, address _mechanism)
        public
        onlyOwner
    {
        _addMechanism(_rewardToken, _mechanism);
    }

    function rewards(address _rewardToken, uint256 _tokenId)
        public
        view
        returns (uint256)
    {
        require(totalSupply() > _tokenId, "token does not exist");
        return _rewards(_rewardToken, _tokenId);
    }

    function claim(address _rewardToken, uint256 _tokenId) public {
        require(totalSupply() > _tokenId, "token does not exist");
        _claim(_rewardToken, _tokenId);
    }
}
