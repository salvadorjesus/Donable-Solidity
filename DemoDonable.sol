// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./Donable.sol";

contract DemoDonable is Donable
{
    uint public contractMoney;

    function doSomethingFor1000WeiA() public payable
    {
        require(msg.value >= 1000, "Not enough WEI. Please send 1000 or more");
        contractMoney += 1000;
        keepTheChange(1000);
    }

    function doSomethingFor1000WeiB() public payable
    {
        require(msg.value >= 1000, "Not enough WEI. Please send 1000 or more");
        contractMoney += 1000;
        uint donation = msg.value - 1000;
        donateAmount(donation);
    }
}