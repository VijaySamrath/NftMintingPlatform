const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("Nft MintingPlatform", async function () {

    async function deploy() {

        const ERC721Creator = await ethers.getContractFactory("ERC721Creator")
        eRC721Creator = await ERC721Creator.deploy("TestToken", "TT")
        await eRC721Creator.deployed()
        console.log("ERC721Creator deployed to address:", eRC721Creator.address)
      
        const MockExtension= await ethers.getContractFactory("MockExtension");
        mockExtension = await MockExtension.deploy(eRC721Creator.address)
        await mockExtension.deployed()
        console.log("MockExtension deployed to address:", mockExtension.address)
    }

    before("Before", async () => {
        accounts = await ethers.getSigners();
        await deploy()

    })

    it("REGISTER Extension & Minting", async () => {
        await eRC721Creator.registerExtension(mockExtension.address, "")
        // console.log("registered extension", await eRC721Creator.getExtensions());

        await eRC721Creator["mintBase(address)"](accounts[1].address) // when there are two function with the 
        // the same name we pass the arguments given in this.
        console.log("Balance of account[1]", await eRC721Creator.balanceOf(accounts[1].address));

        await eRC721Creator["mintBase(address,string)"](accounts[1].address , "")
        console.log("Balance of account[1]", await eRC721Creator.balanceOf(accounts[1].address));
        
        //Mint token for the Extension 
        await mockExtension.testMint(accounts[1].address)
        console.log("Balance of account[1]", await eRC721Creator.balanceOf(accounts[1].address));
        console.log("Balance of extension", await eRC721Creator.tokenExtension(3));

    })

    it("Transfer of Tokens" , async () => {
        await eRC721Creator.connect(accounts[1]).transferFrom(accounts[1].address, accounts[2].address, 1)
        await eRC721Creator.connect(accounts[1]).transferFrom(accounts[1].address, accounts[2].address, 2)
        await eRC721Creator.connect(accounts[1]).transferFrom(accounts[1].address, accounts[2].address, 3)
        
        await eRC721Creator.connect(accounts[2])["safeTransferFrom(address,address,uint256)"](accounts[2].address, accounts[1].address, 3)

    })

    // Using the Extension we can add the Token Uri for the specific token minted by the Extension

    it("set Token Uri for th specific Token Id set for the Extension" , async() => {
        await mockExtension.setTokenURI("https//.JAKLLFJJFLASHJ")
        console.log("Token URI for the Extension", await mockExtension.tokenURI(eRC721Creator.address, 3))
    })

    it("Burn the token of the Extension" , async() => {
       console.log("Owner of token Id 3 ", await eRC721Creator.ownerOf(3));

       await eRC721Creator.connect(accounts[1]).burn(3)
       await expect(eRC721Creator.ownerOf(3)).to.be.reverted
    })

    // it("unregister Extension and minting using extension" , async() => {

    //     await eRC721Creator.unregisterExtension(mockExtension.address)
    //     console.log("registered extension", await eRC721Creator.getExtensions());

    //     await expect(mockExtension.testMint(accounts[3].address)).to.be.reverted
    //     console.log("Balance of account[2]", await eRC721Creator.balanceOf(accounts[3].address));

    // })

    //Comment the ("unregister Extension and minting using extension") and try this

    it("blacklist extension and test the Minting" , async() => {
        
        await eRC721Creator.blacklistExtension(mockExtension.address)
        console.log("balcklisted extension", await eRC721Creator.getExtensions());
    
    })
  
})