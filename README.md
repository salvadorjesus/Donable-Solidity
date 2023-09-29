# Donable-Solidity
When writing a solidity contract that provides a service you might want to add a donation feature that would allow your users to donate a certain amount of Eth to express their gratitude for your effort.
This repository contains a Solidity smart contract (`Donable.sol`) that you can inherit from to provide your contract with such feature.
A `DemoDonable.sol` as an example usage contract is also provided.
An `Ownable.sol` contract that provides ownership functionality is inherited by Donable.sol.
There is also a _Truffle test_ folder with files for testing the contracts in a Truffle project.
## Contracts

![Donable uml](https://github.com/salvadorjesus/Donable-Solidity/assets/637125/fada73ec-b592-4cec-aa8f-32ce910e3036)

### Ownable.sol

This contract provides basic ownership functionality. It allows you to set and change the owner of a contract. The owner has certain privileges, and only the owner can perform certain actions within the contract.

#### Functions and Events

- `constructor()`: Initializes the contract with the deployer as the initial owner.
- `changeOwner(address newOwner)`: Allows the current owner to change the owner to a new address.
- `getOwner()`: Retrieves the current owner's address.
- `requireOwner` modifier: Used to restrict access to certain functions to the contract owner.
- `OwnerSet` event: Emitted when ownership is changed.

### Donable.sol

This contract extends the functionality of `Ownable.sol` and introduces the ability to receive and track donations. Users can donate Ether to the contract, either directly or by sending more Eth than needed to a child contract. `Donable.sol` will keep track of the donated amount.

#### Functions and Events

- `donate()`: Allows users to donate Ether directly to the contract.
- `withdrawDonations()`: Allows the owner to withdraw all stored donations.
- `donateAmount(uint donation)`: Internal function to allow a child contract to keep track of a donation. The child contract specifies the donated amount.
- `keepTheChange(uint spentAmount)`: Internal function to allow a child contract to keep track of a donation. The child contract specifies the cost of the service and `Donable.sol` calculate what’s been donated (the rest).
- `DonationMade` event: Emitted when a donation is made.
- `donationPot` variable: Stores the total amount of Ether donated to the contract.

### DemoDonable.sol

This contract is a demonstration of how to use `Donable.sol`. It inherits from `Donable.sol` and showcases two functions that simulate charging users and handling donations.

#### Functions

- `doSomethingFor1mEtherKeepTheChange()`: Simulates charging the user for 1 milliEther and keeping the rest as a donation. It uses the `keepTheChange(uint spentAmount)` function of `Donable.sol`.
- `doSomethingFor1mEtherAndDonateTheRest()`: Simulates charging the user for 1 milliEther and donating the rest. It uses the `donateAmount(uint donation)` function of `Donable.sol`.
- `withdrawAllFunds()`: Allows the owner to withdraw contract funds *and* the donation pot. This would *not* update the `donationPot` variable and is an example of misuse. However, `Donable.sol` should adapt gracefully.
- `withdrawContractFunds()`: Allows the owner to withdraw contract funds, without affecting the donation pot.
- `contractFunds` variable: Tracks the amount of Ether charged to users.

## Running Tests

To run the tests for these contracts you need a Truffle project set up. Please read the README.md file of the _Truffle test_ folder for further details.

## License

These smart contracts are provided under the [MIT License](LICENSE).
