const Ownable = artifacts.require("Ownable");

contract("Ownable", (accounts) => {
  let ownableInstance;
  const owner = accounts[0];
  const newOwner = accounts[1];

  before(async () => {
    ownableInstance = await Ownable.deployed();
  });

  it("should deploy with the sender as the owner", async () => {
    const contractOwner = await ownableInstance.getOwner();
    assert.equal(contractOwner, owner, "Owner was not set correctly in the constructor");
  });

  it("should allow the owner to change the owner", async () => {
    await ownableInstance.changeOwner(newOwner, { from: owner });
    const contractOwner = await ownableInstance.getOwner();
    assert.equal(contractOwner, newOwner, "Owner was not changed correctly");
  });

  it("should not allow a non-owner to change the owner", async () => {
    try {
      await ownableInstance.changeOwner(newOwner, { from: accounts[2] });
      assert.fail("Changing owner by a non-owner should have thrown an error");
    } catch (error) {
      assert.include(error.message, "revert", "Expected a revert error");
    }
  });
});
