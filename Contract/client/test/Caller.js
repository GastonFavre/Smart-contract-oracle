const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("Caller contract", function () {
  async function deployCallerFixture() {
    const [owner] = await ethers.getSigners();
    const Caller = await ethers.getContractFactory("Caller");
    const deployedContract = await Caller.deploy(owner.address);

    return { owner: owner, contract: deployedContract };
  };

  async function deployOracleFixture() {
    const [owner] = await ethers.getSigners();
    const Oracle = await ethers.getContractFactory("Oracle");
    const deployedContract = await Oracle.deploy();

    return { owner: owner, contract: deployedContract };
  };

  describe("Deployment Caller", function () {

    it("Should set the right owner", async function () {
      const { owner, contract } = await loadFixture(deployCallerFixture);
      const ownerContractCaller = await contract.owner();

      expect(ownerContractCaller).to.equal(owner.address);
    })
  });

  describe(("Deployment Oracle"), function () {

    it("There should be a contract address", async function () {
      const { contract } = await loadFixture(deployOracleFixture);

      expect(contract.address).to.not.be.undefined;
      expect(contract.address).to.not.be.null;
    })
  });

  describe("Setting the oracle address in the call contract", function () {

    it("Should issue the oracle address change event", async function () {
      const callerFixture = await loadFixture(deployCallerFixture);
      const oracleFixture = await loadFixture(deployOracleFixture);

      const callerContract = callerFixture.contract;
      const oracleContract = oracleFixture.contract;
      const oracleAddress = oracleContract.address;

      await expect(callerContract.setOracleAddress(oracleAddress))
        .to.emit(callerContract, "OracleAddressChanged")
        .withArgs(oracleAddress);
    });
  });

  describe("Request the winner of the fight", function () {

    it("Should add a data provider to the oracle", async function () {
      const [owner, provider] = await ethers.getSigners();
      const oracleFixture = await loadFixture(deployOracleFixture);
      const oracleContract = oracleFixture.contract;

      await expect(oracleContract.addProvider(provider.address))
        .to.emit(oracleContract, "ProviderAdded");
    });

    it("You should request the winner of the fight and issue the WinnerFightRequested event", async function () {
      const [owner, provider] = await ethers.getSigners();
      const callerFixture = await loadFixture(deployCallerFixture);
      const oracleFixture = await loadFixture(deployOracleFixture);

      const callerContract = callerFixture.contract;
      const oracleContract = oracleFixture.contract;
      const oracleAddress = oracleContract.address;

      await oracleContract.addProvider(provider.address);
      await callerContract.setOracleAddress(oracleAddress);

      await expect(callerContract.getWinnerFight())
        .to.emit(callerContract, "WinnerFightRequested");
    });

    it("Should complete a fight winner request", async function () {
      const [owner, provider] = await ethers.getSigners();

      const Caller = await ethers.getContractFactory("Caller");
      const Oracle = await ethers.getContractFactory("Oracle");

      const callerContract = await Caller.deploy(owner.address);
      const oracleContract = await Oracle.deploy();

      await callerContract.setOracleAddress(oracleContract.address);
      await oracleContract.addProvider(provider.address);

      const receipt = await callerContract.getWinnerFight();
      const logs = await ethers.provider.getLogs({ transactionHash: receipt.hash });
      const winnerFightRequestedLog = logs.find((log) => {
        try {
          const parsedLog = callerContract.interface.parseLog(log);
          return parsedLog.name === "WinnerFightRequested";
        } catch (error) {
          return false;
        }
      });
      const parsedData = callerContract.interface.parseLog(winnerFightRequestedLog);
      const idRequest = parsedData.args[0].toNumber();

      await expect(oracleContract.connect(provider).returnWinnerFight("Pedro", callerContract.address, idRequest))
      .to.emit(oracleContract , "WinnerFightReturned")

    });
  });
});