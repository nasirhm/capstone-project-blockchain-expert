var capstone = artifacts.require("./capstone.sol");

module.exports = function(deployer) {
  deployer.deploy(capstone);
};