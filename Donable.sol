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

    /**
    * @dev Modifier for a payable function of a child contract to accept
    * implicit donations. All WEI sent msg.amount not used in the function can
    * be stored in the change variable by the developer, and the contract will
    * keep track of said amount as a donation.
    */
    modifier keepTheChange ()
    {
        uint change;
        _;
        donateAmount(change);
    }

    /**
     * @notice Send all stored donations to the contract owner.
     */
    function claimDonations() public requireOwner
    {
        address payable to = payable(super.getOwner());
        //Checks - effect - interaction pattern
        uint donationsToSend;
        // Resiliency check for potential misuse by the contract developer.
        if (address(this).balance >= donationPot)
            donationsToSend = donationPot;
        else
            donationsToSend = address(this).balance;

        donationPot = 0;
        to.transfer(donationsToSend);
    }

    /**
    * @notice Use this function to make a donation to the contract owner.
    */
    function donate() public payable
    {
        donateAmount(msg.value);
    }

    function donateAmount(uint donation) internal
    {        
        if (donation > 0)
        {
            donationPot += donation;
            emit DonationMade(msg.sender, donation);
        }
    }
}