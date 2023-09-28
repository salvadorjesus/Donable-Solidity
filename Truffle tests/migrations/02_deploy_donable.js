const Donable = artifacts.require("Donable");

module.exports = function (deployer) {
  // Despliega el contrato Donable
  deployer.deploy(Donable);
};
