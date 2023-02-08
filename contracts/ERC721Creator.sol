// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./core/ERC721CreatorCore.sol";

contract ERC721Creator is Ownable, ERC721, ERC721CreatorCore {

    constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) {
    }
   
    function registerExtension(address extension, string calldata baseURI) external override onlyOwner {
        requireNonBlacklist(extension);
        _registerExtension(extension, baseURI);
    }

    function unregisterExtension(address extension) external override onlyOwner {
        _unregisterExtension(extension);
    }


    function blacklistExtension(address extension) external override onlyOwner {
        _blacklistExtension(extension);
    }
    

    function setBaseTokenURIExtension(string calldata uri) external override {
        requireExtension();
        _setBaseTokenURIExtension(uri);
    }

    // {ICreatorCore-setTokenURIExtension}.

    function setTokenURIExtension(uint256 tokenId, string calldata uri) external override {
        requireExtension();
        _setTokenURIExtension(tokenId, uri);
    }

    //  {ICreatorCore-setTokenURIExtension}.
    
    function setTokenURIExtension(uint256[] memory tokenIds, string[] calldata uris) external override {
        requireExtension();
        require(tokenIds.length == uris.length, "Invalid input");
        for (uint i; i < tokenIds.length;) {
            _setTokenURIExtension(tokenIds[i], uris[i]);
        }
    }

    // {ICreatorCore-setBaseTokenURI}.
     
    function setBaseTokenURI(string calldata uri) external override onlyOwner {
        _setBaseTokenURI(uri);
    }


    //  {ICreatorCore-setTokenURI}.
     
    function setTokenURI(uint256 tokenId, string calldata uri) external override onlyOwner {
        _setTokenURI(tokenId, uri);
    }

    //  {IERC721CreatorCore-mintBase}.
     
    function mintBase(address to) public virtual override nonReentrant onlyOwner returns(uint256) {
        return _mintBase(to, "");
    }

    //  {IERC721CreatorCore-mintBase}.
    
    function mintBase(address to, string calldata uri) public virtual override nonReentrant onlyOwner returns(uint256) {
        return _mintBase(to, uri);
    }
 
    //  Mint token with no extension
    
    function _mintBase(address to, string memory uri) internal virtual returns(uint256 tokenId) {
        ++_tokenCount;
        tokenId = _tokenCount;

        _safeMint(to, tokenId);

        if (bytes(uri).length > 0) {
            _tokenURIs[tokenId] = uri;
        }
    }

    // {IERC721CreatorCore-mintExtension}.
    
    function mintExtension(address to) public virtual override nonReentrant returns(uint256) {
        requireExtension();
        return _mintExtension(to, "");
    }

    // {IERC721CreatorCore-mintExtension}.
    
    function mintExtension(address to, string calldata uri) public virtual override nonReentrant returns(uint256) {
        requireExtension();
        return _mintExtension(to, uri);
    }
  
    //  Mint token via extension
     
    function _mintExtension(address to, string memory uri) internal virtual returns(uint256 tokenId) {
        ++_tokenCount;
        tokenId = _tokenCount;
        // Track the extension that minted the token
        _tokensExtension[tokenId] = msg.sender;

        _safeMint(to, tokenId);

        if (bytes(uri).length > 0) {
            _tokenURIs[tokenId] = uri;
        }
    }

    // {IERC721CreatorCore-tokenExtension}.
    
    function tokenExtension(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "Nonexistent token");
        return _tokenExtension(tokenId);
    }

      function burn(uint256 tokenId) public virtual override nonReentrant {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Caller is not owner nor approved");
        _burn(tokenId);
    }

}
