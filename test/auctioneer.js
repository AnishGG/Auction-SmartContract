const Auctioneer = artifacts.require('./Auctioneer.sol')
const assert = require('assert')

let contractInstance

   contract('Auctioneer',  (accounts) => {
    var p = new Array()
    for(i = 0; i < 10; i++) {
        p[i] = accounts[i];
        console.log(p[i]);
    }
    beforeEach(async () => {
      contractInstance = await Auctioneer.deployed()
   })
   i = 0;
   
   for(i = 0; i < 8; i+=2) {
       const z =  i;
   it('Check if notary is getting registered', async() => {     
      var prevcnt = await contractInstance.getnotary()
      console.log(p[z]);      
      console.log(z) ;
      await contractInstance.registerNotary({from: p[z]})
      var newcnt = await contractInstance.getnotary()
       console.log(newcnt);      
      assert.equal(prevcnt.c[0] + 1, newcnt.c[0], 'Notary is not registered')
   })
   it('Check if bidder is getting registered', async() => {     
    var prevcnt = await contractInstance.getbidder()
    console.log(prevcnt)
    await contractInstance.registerBidder([2,3],[18,18], 5, 15, {from: p[z+1]})
    var newcnt = await contractInstance.getbidder()
    console.log(newcnt)      
    assert.equal(prevcnt.c[0] + 1, newcnt.c[0], 'Bidder is not registered')
    })   
    }


})