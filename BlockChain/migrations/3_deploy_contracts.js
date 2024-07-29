var Medicine = artifacts.require("./Patient.sol");

module.exports = function(deployer) {
  deployer.deploy(Medicine);
};