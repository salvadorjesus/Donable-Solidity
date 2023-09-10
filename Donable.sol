// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/**
 * @title Donable
 * @dev Provide functionality for a contract to receive donations.
 */
import "./Ownable.sol";

contract Donable is Ownable
{
    uint private donationPot;

    event DonationMade(address indexed donor, uint donation);

    modifier keepTheChange ()
    {
        uint change;
        _;
        donateAmount(change);
    }

    /**
     * @dev Send all stored donation to the contract owner.
     */
    function claimDonations() public requireOwner
    {
        address payable to = payable(super.getOwner());
        //Checks - effect - interaction pattern
        uint donationsToSend = donationPot;
        donationPot = 0;
        to.transfer(donationsToSend);
    }

    function donate() public payable
    {
        donationPot += msg.value;
        emit DonationMade(msg.sender, msg.value);
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