var Ponzi = artifacts.require("./Ponzi.sol");

module.exports = function(deployer) {
  deployer.deploy(Ponzi);
};
