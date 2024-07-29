var Medicine = artifacts.require("./XRay.sol");

module.exports = function(deployer) {
  deployer.deploy(Medicine);
};