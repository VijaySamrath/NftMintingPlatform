// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../core/IERC721CreatorCore.sol";

contract MockExtension  {

    bool _approveEnabled;
    string _tokenURI;
    address _creator;

    constructor(address creator) {
        _creator = creator;
    }

    function testMint(address to) public {
        IERC721CreatorCore(_creator).mintExtension(to);
    }

    function setApproveEnabled(bool enabled) public {
        _approveEnabled = enabled;
    }

    function setTokenURI(string calldata uri) public {
        _tokenURI = uri;
    }

       function tokenURI(address creator, uint256) public view  returns (string memory) {
        require(creator == _creator, "Invalid");
        return _tokenURI;
    }

}
