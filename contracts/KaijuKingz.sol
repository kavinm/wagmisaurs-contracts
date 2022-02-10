// SPDX-License-Identifier: MIT
//         _              _                    _              _      _
//        /\_\           / /\                 /\ \           /\ \   /\_\
//       / / /  _       / /  \                \ \ \          \ \ \ / / /         _
//      / / /  /\_\    / / /\ \               /\ \_\         /\ \_\\ \ \__      /\_\
//     / / /__/ / /   / / /\ \ \             / /\/_/        / /\/_/ \ \___\    / / /
//    / /\_____/ /   / / /  \ \ \           / / /  _       / / /     \__  /   / / /
//   / /\_______/   / / /___/ /\ \         / / /  /\ \    / / /      / / /   / / /
//  / / /\ \ \     / / /_____/ /\ \       / / /   \ \_\  / / /      / / /   / / /
// / / /  \ \ \   / /_________/\ \ \  ___/ / /__  / / /_/ / /      / / /___/ / /
/// / /    \ \ \ / / /_       __\ \_\/\__\/_/___\/ / /__\/ /      / / /____\/ /
//\/_/      \_\_\\_\___\     /____/_/\/_________/\/_______/       \/_________/
//
//
//        /\_\            /\ \       /\ \     _    /\ \         /\ \
//       / / /  _         \ \ \     /  \ \   /\_\ /  \ \       /  \ \
//      / / /  /\_\       /\ \_\   / /\ \ \_/ / // /\ \_\   __/ /\ \ \
//     / / /__/ / /      / /\/_/  / / /\ \___/ // / /\/_/  /___/ /\ \ \
//    / /\_____/ /      / / /    / / /  \/____// / / ______\___\/ / / /
//   / /\_______/      / / /    / / /    / / // / / /\_____\     / / /
//  / / /\ \ \        / / /    / / /    / / // / /  \/____ /    / / /    _
// / / /  \ \ \   ___/ / /__  / / /    / / // / /_____/ / /     \ \ \__/\_\
/// / /    \ \ \ /\__\/_/___\/ / /    / / // / /______\/ /       \ \___\/ /
//\/_/      \_\_\\/_________/\/_/     \/_/ \/___________/         \/___/_/
//An Augminted Labs Project

pragma solidity ^0.8.0;

import "./KaijuKingzERC721.sol";

interface IRWaste {
    function burn(address _from, uint256 _amount) external;

    function updateReward(address _from, address _to) external;
}

contract KaijuKingz is KaijuKingzERC721 {
    struct KaijuData {
        string name;
        string bio;
    }

    modifier kaijuOwner(uint256 kaijuId) {
        require(
            ownerOf(kaijuId) == msg.sender,
            "Cannot interact with a KaijuKingz you do not own"
        );
        _;
    }

    IRWaste public RWaste;

    uint256 public constant FUSION_PRICE = 750 ether;
    uint256 public constant NAME_CHANGE_PRICE = 150 ether;
    uint256 public constant BIO_CHANGE_PRICE = 150 ether;

    constructor(
        string memory name,
        string memory symbol,
        uint256 supply,
        uint256 genCount
    ) KaijuKingzERC721(name, symbol, supply, genCount) {}

    function setRadioactiveWaste(address rWasteAddress) external onlyOwner {
        RWaste = IRWaste(rWasteAddress);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        if (tokenId < maxGenCount) {
            RWaste.updateReward(from, to);
            balanceGenesis[from]--;
            balanceGenesis[to]++;
        }
        ERC721.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override {
        if (tokenId < maxGenCount) {
            RWaste.updateReward(from, to);
            balanceGenesis[from]--;
            balanceGenesis[to]++;
        }
        ERC721.safeTransferFrom(from, to, tokenId, data);
    }
}
