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
    uint public contractMoney;

    /**
    * @notice Emulates doing charging the user for 1000 Wei and keeping
    * the rest of money transferred in the transaction as a donation.
    * @dev Uses the Donable function keepTheChange().
    */
    function doSomethingFor1000WeiA() public payable
    {
        require(msg.value >= 1000, "Not enough WEI. Please send 1000 or more");
        contractMoney += 1000;
        keepTheChange(1000);
    }

    /**
    * @notice Emulates doing charging the user for 1000 Wei and keeping
    * the rest of money transferred in the transaction as a donation.
    * @dev Uses the Donable function donateAmount(uint donation).
    */
    function doSomethingFor1000WeiB() public payable
    {
        require(msg.value >= 1000, "Not enough WEI. Please send 1000 or more");
        contractMoney += 1000;
        uint donation = msg.value - 1000;
        donateAmount(donation);
    }

    //TODO a function to retire all contract funds.
    //TODO a function to retire all contract funds minus donations.
}