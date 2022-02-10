// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  //deploy Kaiju NFT first
  const Kaiju = await hre.ethers.getContractFactory("KaijuKingz");
  /*
  parameters are         
  string memory name,
  string memory symbol,
  uint256 supply,
  uint256 genCount 
  */
  const kaiju = await Kaiju.deploy("WagmiTestRun", "WAGMITEST", 9999, 3333);

  await kaiju.deployed();

  console.log("Kaiju deployed to:", kaiju.address);

  const RadioactiveWaste = await hre.ethers.getContractFactory(
    "RadioactiveWaste"
  );

  /*
  parameters are         
  string memory name,

  */
  const radioactiveWaste = await RadioactiveWaste.deploy(kaiju.address);

  await radioactiveWaste.deployed();

  console.log("RadioActive Waste deployed to:", radioactiveWaste.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
