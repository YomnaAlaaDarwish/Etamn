var Medicine = artifacts.require("./Prescription.sol");

module.exports = function(deployer) {
  deployer.deploy(Medicine);
};