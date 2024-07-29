var Medicine = artifacts.require("./Blood.sol");

module.exports = function(deployer) {
  deployer.deploy(Medicine);
};