const Donable = artifacts.require("Donable");
const DemoDonable = artifacts.require("DemoDonable");

contract("DemoDonable", (accounts) => {
  let demoDonableInstance;
  const owner = accounts[0];
  const donor = accounts[1];

  before(async () => {
    demoDonableInstance = await DemoDonable.deployed();
  });

  it("should deploy with the sender as the owner", async () => {
    const demoDonableOwner = await demoDonableInstance.getOwner();
    assert.equal(demoDonableOwner, owner, "Owner was not set correctly in the constructor");
  });

  it("should receive donations using Donable's keep the change", async () => {
    const initialDonationPot = await demoDonableInstance.donationPot();
    await demoDonableInstance.doSomethingFor1mEtherKeepTheChange({ from: donor, value: web3.utils.toWei("2", "ether") });
    const finalDonationPot = await demoDonableInstance.donationPot();

    var donationReceived = finalDonationPot - initialDonationPot;
    var expectedDonation = web3.utils.toWei("2", "ether") - web3.utils.toWei("1", "milli")

    assert.equal(donationReceived, expectedDonation, "Donation received is not what's expected");
  });

  it("should receive donations using Donable's donateAmount", async () => {
    const initialDonationPot = await demoDonableInstance.donationPot();
    await demoDonableInstance.doSomethingFor1mEtherAndDonateTheRest({ from: donor, value: web3.utils.toWei("2", "ether") });
    const finalDonationPot = await demoDonableInstance.donationPot();

    var donationReceived = finalDonationPot - initialDonationPot;
    var expectedDonation = web3.utils.toWei("2", "ether") - web3.utils.toWei("1", "milli")

    assert.equal(donationReceived, expectedDonation, "Donation received is not what's expected.");
  });

  it("should allow the owner to withdraw contract funds without altering the donation pot.", async () => {
    const initialBalance = await web3.eth.getBalance(owner);
    const initialDonationPot = await demoDonableInstance.donationPot();
    
    await demoDonableInstance.withdrawContractFunds({ from: owner });
    
    const finalBalance = await web3.eth.getBalance(owner);
    const finalDonationPot = await demoDonableInstance.donationPot();
    const contractAddressValue = await web3.eth.getBalance(demoDonableInstance.address);

    assert.isAbove(Number(finalBalance), Number(initialBalance),
     "Owner's balance should have increased.");
    assert.equal(Number(initialDonationPot), Number(finalDonationPot),
     "Donation pot should remain unchanged during contract funds withdrawal.")
    assert.equal(finalDonationPot, contractAddressValue,
     "The donation pot should match the contract's address balance after contract funds withdrawal.");
  });

  it("should keep track of contract funds", async () => {
    await demoDonableInstance.doSomethingFor1mEtherKeepTheChange({ from: donor, value: web3.utils.toWei("1", "ether") });
    const contractFunds1 = await demoDonableInstance.contractFunds();
    assert.equal(contractFunds1, web3.utils.toWei("1", "milli"),
      "Contract funds were not tracked correctly");

    await demoDonableInstance.doSomethingFor1mEtherAndDonateTheRest({ from: donor, value: web3.utils.toWei("1", "ether") });
    const contractFunds2 = await demoDonableInstance.contractFunds();
    assert.equal(contractFunds2, web3.utils.toWei("2", "milli"),
      "Contract funds were not tracked correctly after a second donation");

    await demoDonableInstance.withdrawDonations({ from: owner });
    const contractFunds3 = await demoDonableInstance.contractFunds();
    assert.equal(contractFunds3, web3.utils.toWei("2", "milli"),
      "Contract funds were not tracked correctly after emptying the donation pot");

    const contractAddressValue = await web3.eth.getBalance(demoDonableInstance.address);
    assert.equal(contractFunds2, contractAddressValue,
      "The contract funds should match the contract's address balance after donations withdrawal.");
  });

  it("should not fail when withdrawing donations if the owner has previously depleted the contract address balance.", async() => {
    await demoDonableInstance.withdrawAllFunds({ from: owner });
    try {
      await demoDonableInstance.withdrawDonations({ from: owner });
    } catch (error) {
      assert.fail("withdrawDonations() failed when attempting to withdraw donations without sufficient"+
        " funds on the contract address balance: " +
        error.message);
    }
  });

});
