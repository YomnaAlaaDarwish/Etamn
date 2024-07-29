var Medicine = artifacts.require("./Doctor.sol");

module.exports = function(deployer) {
  deployer.deploy(Medicine);
};