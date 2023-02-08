const { ethers } = require("hardhat");

async function main() {

  const ERC721Creator = await ethers.getContractFactory("ERC721Creator")
  const eRC721Creator = await ERC721Creator.deploy("TestToken", "TT")
  await eRC721Creator.deployed()
  console.log("ERC721Creator deployed to address:", eRC721Creator.address)

  const MockExtension= await ethers.getContractFactory("MockExtension");
  const mockExtension = await MockExtension.deploy(eRC721Creator.address)
  await mockExtension.deployed()
  console.log("MockExtension deployed to address:", mockExtension.address)

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })