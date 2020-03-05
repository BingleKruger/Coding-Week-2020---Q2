const truffleAssert = require('truffle-assertions')
// import the contract artifact
const CO = artifacts.require('./CO.sol')


// test starts here
contract('CO', function (accounts) {
  // predefine the contract instance
  let COInstance

  // before each test, create a new contract instance
  beforeEach(async function () {
    COInstance = await CO.new()
  })

  // first test: 
  it('Any account can mint CO tokens', async function () {
    let tokenPrice = await COInstance.buyPrice(20)
    await COInstance.mint(20 ,{'from' : accounts[1], 'value' : tokenPrice})
    let numTokens = await COInstance.numCO()
    let accBalance = await COInstance.balanceOf(accounts[1])
    // check whether minter is equal to account 0
    assert.equal(numTokens, 20, "Problem minting tokens")
    assert.equal(accBalance, 20, "Problem assigning tokens to account")
  })

  // second test: 
  it('Only Co can burn tokens', async function () {
    let tokenBuyPrice = await COInstance.buyPrice(15)
    await COInstance.mint(15 ,{'from' : accounts[0], 'value' : tokenBuyPrice})
    let tokenSellPrice = await COInstance.sellPrice(10)
    await COInstance.burn(10, {'from' : accounts[0]})
    let Contractbal = await COInstance.testgetBalance();
    let numTokens = await COInstance.numCO()
    let NetBalance = tokenBuyPrice-tokenSellPrice
    assert.equal(numTokens, 5, "Problem burning tokens")
    assert.equal(NetBalance.toString(), Contractbal.toString(), "Ether not transferred")
  })

  // third test: 
  it('The destroy function works', async function () {
    await truffleAssert.reverts(COInstance.destroy())
  })



})