const Auctioneer = artifacts.require('./Auctioneer.sol')
const assert = require('assert')

let contractInstance

   contract('Auctioneer',  (accounts) => {
   beforeEach(async () => {
      contractInstance = await Auctioneer.deployed()
   })
   
   it('Check if notary is getting registered', async () => {     
      const prevcnt = await contractInstance.getnotary()
      await contractInstance.registerNotary()
     
      const newcnt = await contractInstance.getnotary()
      assert.equal(prevcnt.c[0]+1,newcnt.c[0], 'Notary is not registered')
   })
   /*
   it('should add a to-do note successfully with a short text of 20 letters', async () => {
      await contractInstance.addTodo(web3.toHex('this is a short text'))
      const newAddedTodo = await contractInstance.todos(accounts[0], 0)
      const todoContent = web3.toUtf8(newAddedTodo[1])
      
      assert.equal(todoContent, 'this is a short text', 'The content of the new added todo is not correct')
   })
   it('should mark one of your to-dos as completed', async () => {
   await contractInstance.addTodo('example')
   await contractInstance.markTodoAsCompleted(0)
   const lastTodoAdded = await contractInstance.todos(accounts[0], 0)
   const isTodoCompleted = lastTodoAdded[3] // 3 is the bool isCompleted value of the todo note
   assert(isTodoCompleted, 'The todo should be true as completed')
})*/

})