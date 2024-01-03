const hre = require("hardhat");

async function main() {

  try {
    const OracleContract = await hre.ethers.getContractFactory('Oracle');

    const oracleContract = await OracleContract.deploy();

    console.log('Contract deployed at the address:', oracleContract.address);
  } catch (error) {
    console.error(error)
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
