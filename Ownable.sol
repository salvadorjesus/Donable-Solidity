// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Ownable
 * @dev Set & change owner. A modification of the sample contract on Remix.
 */
contract Ownable {

    /**
    * @dev Storage variable to keep track of the contract owner.
    */
    address private owner;
    
    /**
    * @dev Event for EVM logging. Emitted during owner change or contract creation.
    */ 
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    /**
    * @dev Modifier to check if the function caller is owner
    */
    modifier requireOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    /**
     * @dev Constructor. Sets the contract deployer as owner. 
     */
    constructor() {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner);
    }

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    function changeOwner(address newOwner) public requireOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Return owner address 
     * @return address of owner
     */
    function getOwner() public view returns (address) {
        return owner;
    }
}