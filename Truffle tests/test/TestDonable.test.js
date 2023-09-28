const Donable = artifacts.require("Donable");

contract("Donable", (accounts) => {
  let donableInstance;
  const owner = accounts[0];
  const donor = accounts[1];

  before(async () => {
    donableInstance = await Donable.deployed();
  });

  it("should deploy with the sender as the owner", async () => {
    const contractOwner = await donableInstance.getOwner();
    assert.equal(contractOwner, owner, "Owner was not set correctly in the constructor");
  });

  it("should allow the owner to withdraw donations", async () => {
    const initialBalance = await web3.eth.getBalance(owner);
    await donableInstance.donate({ from: donor, value: web3.utils.toWei("1", "ether") });
    await donableInstance.withdrawDonations({ from: owner });
    const finalBalance = await web3.eth.getBalance(owner);
    const donationPot = await donableInstance.donationPot();

    assert.equal(Number(donationPot), 0, "DonationPot should be 0 after withdrawal ");
    assert.isAbove(Number(finalBalance), Number(initialBalance), "Owner's balance should have increased");
  });

  it("should emit DonationMade event when a donation is made", async () => {
    const tx = await donableInstance.donate({ from: donor, value: web3.utils.toWei("0.5", "ether") });
    const donationEvent = tx.logs.find((log) => log.event === "DonationMade");

    assert.isDefined(donationEvent, "DonationMade event was not emitted");
    assert.equal(donationEvent.args.donor, donor, "DonationMade event donor address is incorrect");
    assert.equal(donationEvent.args.donation.toString(), web3.utils.toWei("0.5", "ether"), "DonationMade event donation amount is incorrect");
  });

});
