const CO = artifacts.require("./CO.sol");

module.exports = function(deployer) {
  deployer.deploy(CO);
};
