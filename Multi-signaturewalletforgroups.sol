// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract WatchNFTMarketplace {
    string public name = "Watch NFT Marketplace";
    uint256 public tokenCount;
    address public owner;

    // Struct to represent an NFT in the marketplace
    struct WatchNFT {
        uint256 id;
        address creator;
        address currentOwner;
        string name;
        uint256 price;
    }

    // Mapping from token ID to WatchNFT details
    mapping(uint256 => WatchNFT) public watchNFTs;

    event WatchNFTCreated(uint256 tokenId, string name, uint256 price);
    event WatchNFTTransferred(uint256 tokenId, address from, address to);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this");
        _;
    }

    constructor() {
        owner = msg.sender;  // Set the owner to the address deploying the contract
    }

    // Function 1: Create a new Watch NFT
    function createWatchNFT(string memory _name, uint256 _price) external {
        uint256 tokenId = tokenCount++;
        WatchNFT memory newWatchNFT = WatchNFT({
            id: tokenId,
            creator: msg.sender,
            currentOwner: msg.sender,
            name: _name,
            price: _price
        });

        watchNFTs[tokenId] = newWatchNFT;
        emit WatchNFTCreated(tokenId, _name, _price);
    }

    // Function 2: Buy/Sell (Transfer) an NFT
    function transferWatchNFT(uint256 _tokenId) external payable {
        WatchNFT storage nft = watchNFTs[_tokenId];
        require(nft.currentOwner != msg.sender, "You already own this NFT");
        require(msg.value == nft.price, "Incorrect payment amount");

        address previousOwner = nft.currentOwner;
        nft.currentOwner = msg.sender;

        // Transfer payment to the previous owner
        payable(previousOwner).transfer(msg.value);

        emit WatchNFTTransferred(_tokenId, previousOwner, msg.sender);
    }

    // Function to retrieve the contract owner address
    function getOwner() external view returns (address) {
        return owner;
    }
}

