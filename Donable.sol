// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./Ownable.sol";

/**
 * @title Donable
 * @dev Provide functionality for a contract to receive and keep track of donations.
 * The contract user can directly donate to the contract using the public function donate,
 * or any function of a child contract can keep what’s was not used from msg.amount as a
 * donation using the modifier keepTheChange.
 */
contract Donable is Ownable
{
    /** @dev Keeps track of the amount of WEI stored in the contract that is a donation.
    */
    uint private donationPot;

    /**
    * @dev Emitted when a donation is made. Indexed by donor.
    */
    event DonationMade(address indexed donor, uint donation);

    //TODO internal getter for donationPot

    /**
     * @notice Send all stored donations to the contract owner.
     * @dev Be mindful of the fact that the contract has complete control over
     * its fonds. It is possible for Donable to keep track of a donation amount
     * larger or smaller than what is keep in a child contract, either
     * because of the contract has spent it, or because donations have been
     * overestimated by the developer.
     */
    function withdrawDonations() public requireOwner
    {
        address payable owner = payable(getOwner());
        //Checks - effect - interaction pattern
        uint donationsToSend;
        // Resiliency check for potential misuse by the contract developer.
        if (address(this).balance >= donationPot)
            donationsToSend = donationPot;
        else
            donationsToSend = address(this).balance;

        donationPot = 0;
        owner.transfer(donationsToSend);
    }

    /**
    * @notice Use this function to make a donation to the contract owner.
    */
    function donate() public payable
    {
        donateAmount(msg.value);
    }

    /**
    * @dev Internal function to keep track of a donation. It emits a DonationMade
    * event if donation is greater than zero.
    * @param donation The donated amount that needs to be accounted for.
    */
    function donateAmount(uint donation) internal
    {        
        if (donation > 0)
        {
            donationPot += donation;
            emit DonationMade(msg.sender, donation);
        }
    }

    /**
    * @dev Internal utility function to keep track of a donation. It will 
    * calculate the donation made as the different between spentAmount and
    * msg.value, then use the function donateAmount.
    * @param spentAmount The amount of Wei used by the caller function. The rest
    * of the msg.value is to be accounted as a donation.
    */
    function keepTheChange(uint spentAmount) internal
    {
        //spentAmount could be greater than msg.value in some use cases (i.e.:
        // the user has some kind of credit.)
        if (spentAmount <= msg.value)
        {
            uint change = msg.value - spentAmount;
            donateAmount(change);
        }
    }
}