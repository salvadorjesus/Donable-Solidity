const DemoDonable = artifacts.require("DemoDonable");

module.exports = function (deployer) {
  // Despliega el contrato Donable
  deployer.deploy(DemoDonable);
};
