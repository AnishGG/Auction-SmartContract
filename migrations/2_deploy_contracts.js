var Auctioneer = artifacts.require("./Auctioneer.sol");

module.exports = function(deployer) {
  deployer.deploy(Auctioneer,15,19,4, 4);
};
