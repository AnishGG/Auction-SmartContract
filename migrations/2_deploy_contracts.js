var Auctioneer = artifacts.require("./Auctioneer.sol");

module.exports = function(deployer) {
  deployer.deploy(Auctioneer,[1,2,3],19,1561608000);
};
