
# Oracle basic implementation

In the present implementation, the client will establish communication with the oracle contract through the "caller" contract. The term client includes any entity that has access to a provider, such as a wallet like Metamask. The caller contract will assume responsibility for processing information requests, establishing communication with the oracle contract. In turn, the oracle contract will communicate with a vendor, with the oracle being the combination of the oracle contract and the vendor.

The provider will play the role of processing requests from the oracle contract, returning information obtained from the external environment, for example, through an application programming interface (API). It should be noted that this implementation represents a basic communication flow with an API and does not comprehensively address security and cost issues.




## Steps for execution

Before running the project, make sure you have Node.js and npm installed on your system. You can verify your installation by running the following commands in the terminal:

```bash
node -v
npm -v
```

If they are not installed, download and install Node.js and npm from the official site [Node.js](https://nodejs.org/en).

### Installation


In the "Contract/client", "Contract/oracle" and "Backend" directories, proceed to install the dependencies using the following command:

```bash
npm install
```
    
## Demo

### Start a Hardhat node:
- Run the following command to start a Hardhat node:
```bash
npx hardhat node
```
### Deploying the Caller contract:
- In the "Contract/client/script" directory, deploy the Caller contract with the following command, making sure to specify the address of the contract owner in the deployment script:
```bash
npx hardhat run --network localhost deploy.js
```
### Oracle contract deployment:
- In the "Contract/oracle/script" directory, perform the Oracle contract deployment with the same command mentioned above.
### Start the API in the Backend directory:
- Run the following command to start the API in the "Backend" folder:
```bash
node app.js
```
### Configuration in the Frontend index.js file:
- In the "Frontend" directory, in the "index.js" file, configure the variables required for interaction with contracts. Replace the **abiCaller** and **abiOracle** variables with their corresponding ones, as well as the addresses of the contracts in the **addressCaller** and **addressOracle** variables. Also set the address of the provider chosen to interact with the Oracle contract in **addressProvider**.
### Start a local server with Live Server:
- Use the Live Server plugin according to the [documentation ](https://ritwickdey.github.io/vscode-live-server/).
### Provider configuration
- In the "Contract/oracle/provider" directory, as in the previous step, replace the corresponding variables in the "provider.js" script. Specifically, update the URL where your API is started.
### Create an .env file:
- Create a file named ".env" and add the following content to it:
- ORACLE_ADDRESS="address of the oracle"
- WEB_SOCKET_PROVIDER="ws://127.0.0.1:8545"
### Run the provider.js script:
- Run the following command to start the "provider.js" script:
```bash
node provider.js
```
- Apply for the winner through the graphical interface of the web application.
### Technologies

- Hardhat
- Express
- Ethers.js
- Live Server
- OpenZeppelin Contracts
### Visual Demo
![](https://github.com/GastonFavre/Smart-contract-oracle/blob/main/comunication_flow.gif)
