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
			var prevcnt = await contractInstance.getNotarycnt();
			console.log(p[z]);      
			console.log(z) ;
			await contractInstance.registerNotary({from: p[z]});
			var newcnt = await contractInstance.getNotarycnt();
			console.log(newcnt);      
			assert.equal(prevcnt.c[0] + 1, newcnt.c[0], 'Notary is not registered');6
		})
		it('Check if bidder is getting registered', async() => {     
			var prevcnt = await contractInstance.getBiddercnt();
			console.log(prevcnt);
			await contractInstance.registerBidder([2,3],[18,18], 5, 15, {from: p[z+1]});
			var newcnt = await contractInstance.getBiddercnt();
			console.log(newcnt);
			assert.equal(prevcnt.c[0] + 1, newcnt.c[0], 'Bidder is not registered');
		})   
	}

	it('Check if two notaries with same address can get registered', async() => {
		var prevcnt = await contractInstance.getNotarycnt();
		try {
			await contractInstance.registerNotary({from: p[0]});
		}
		catch(err){
		
		}
		var newcnt = await contractInstance.getNotarycnt();
		assert.equal(prevcnt.c[0], newcnt.c[0], 'Bidder is not registered');
	})

	it('Check if two bidders with same address can get registered', async() => {
		var prevcnt = await contractInstance.getBiddercnt();
		try {
			await contractInstance.registerBidder([2,3],[18,18], 5, 15, {from: p[1]});
		}
		catch(err){
		
		}
		var newcnt = await contractInstance.getBiddercnt();
		assert.equal(prevcnt.c[0], newcnt.c[0], 'Bidder is registered but it should not be');
	})

	it('Check if Bidders items are valid',  async() => {
		var prevcnt = await contractInstance.getBiddercnt();
		try {
			await contractInstance.registerBidder([18,3],[18,18], 5, 15, {from: p[8]});
			assert.ok(false, 'The contract should throw an exception to \
				as the bidder items are not valid')
		}
		catch(err){
			console.log(err.message)
			assert.ok(true, 'The contract is throwing an error as the \
				bidder items are not valid')
		}
	})

	it('Check if Bidder gets added even when notary is not assigned to bidder',  async() => {
		/* Every notary is assigned before this test */
		try {
			await contractInstance.registerBidder([3,3],[18,18], 5, 15, {from: p[8]});
			assert.ok(false, 'The contract should throw an exception to \
				as the bidder items are not valid')
		}
		catch(err){
			console.log(err.message)
			assert.ok(true, 'The contract is throwing an error as the \
				bidder is not registered because notary was not available')
		}
	})

	it('Check if the assigned notary of bidder is not bidder himself',  async() => {
		flag = true;
		for(i = 1; i < 8; i+=2) {
			var x = await contractInstance.getAssignedNotary(p[i]);
			// console.log(x);
			if(x == p[i])
				flag = false;
		}
		assert.equal(flag, true, 'Bidder is Notary of himself')
	})

})
