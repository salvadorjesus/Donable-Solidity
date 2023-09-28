const Ownable = artifacts.require("Ownable");

module.exports = function (deployer) {
  // Despliega el contrato Ownable
  deployer.deploy(Ownable);
};
