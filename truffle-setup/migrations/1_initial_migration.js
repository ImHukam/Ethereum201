const Migrations = artifacts.require("hello");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
