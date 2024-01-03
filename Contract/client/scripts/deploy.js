const hre = require("hardhat");

async function main() {

  try {
    const CallerContract = await hre.ethers.getContractFactory('Caller');

    const callerContract = await CallerContract.deploy("");


    console.log('Contract deployed at the address:', callerContract.address);
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
