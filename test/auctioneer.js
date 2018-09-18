const Auctioneer = artifacts.require('./Auctioneer.sol')
const assert = require('assert')

let contractInstance

contract('Auctioneer', (accounts) => {
    beforeEach(async () => {
       contractInstance = await Auctioneer.deployed()
   })
}
