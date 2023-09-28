// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./Donable.sol";

/**
* @title DemoDonable
* @notice  A demo contract that inherits from Donable and make use of its
* functions to accept donations.
*/
contract DemoDonable is Donable
{
    /**
    * @notice Keep track of the money the contract has charge to its users.
    */
    uint public contractFunds;

    /**
    * @notice Emulates doing charging the user for 1 mEth and keeping
    * the rest of money transferred in the transaction as a donation.
    * @dev Uses the Donable function keepTheChange().
    */
    function doSomethingFor1mEtherKeepTheChange() public payable
    {
        require(msg.value >= 1e15, "Not enough WEI. Please send 1000 or more");
        contractFunds += 1e15;
        keepTheChange(1e15);
    }

    /**
    * @notice Emulates doing charging the user for 1 mEth and keeping
    * the rest of money transferred in the transaction as a donation.
    * @dev Uses the Donable function donateAmount(uint donation).
    */
    function doSomethingFor1mEtherAndDonateTheRest() public payable
    {
        require(msg.value >= 1e15, "Not enough WEI. Please send 1000 or more");
        contractFunds += 1e15;
        uint donation = msg.value - 1e15;
        donateAmount(donation);
    }
    /**
    * @notice Withdraw the funds that the contract accounts for.
    * @dev This will take the donation money accounted for in the extended
    * Donable super contract without update the donation pot variable. However,
    * Donable should detect this when withdrawing donations and adapt gracefully.
    */
    function withdrawAllFunds() public requireOwner()
    {
        contractFunds=0;
        payable(getOwner()).transfer(address(this).balance);
    }

    /**
    * @notice Withdraw the funds that the contract accounts for.
    * @dev This should not interfere with the donation pot stored in the
    *  extended Donable contract.
    */
    function withdrawContractFunds( ) public requireOwner
    {
        //Checks - effect - interaction pattern
        uint moneyToSend = contractFunds;
        contractFunds = 0;
        payable(getOwner()).transfer(moneyToSend);
    }
}