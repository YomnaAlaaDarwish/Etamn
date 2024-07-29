var Medicine = artifacts.require("./Surgery.sol");

module.exports = function(deployer) {
  deployer.deploy(Medicine);
};