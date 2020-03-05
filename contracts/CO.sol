pragma solidity >=0.5.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";


contract CO is ERC20, ERC20Detailed, Ownable {

    using SafeMath for uint256;

    uint coSupply;
    uint numCoTokens;

    address payable minter;

    constructor () ERC20Detailed("CoToken", "CO",18) public { //from https://www.youtube.com/watch?v=wkISWhw7AP0&t=440s
        coSupply = 100;
        numCoTokens = 0;
        minter = msg.sender;
    }

    function buyPrice(uint _numTokens) public view returns (uint) {
        require(numCoTokens + _numTokens <= coSupply, "Amount specified is greater than amount available for purchase");
        uint price = numCoTokens.add(_numTokens) ** 2 + 40 * numCoTokens.add(_numTokens) - numCoTokens ** 2 - 40 * numCoTokens;
        return price * (1 ether)/200; //Can not use ** with rational numbers, thus we use 1/200
    }

    function sellPrice(uint _numTokens) public view returns (uint) {
        require(numCoTokens >= _numTokens, "Amount specified is greater than amount available for sale");
        uint price = numCoTokens ** 2 + 40 * numCoTokens - numCoTokens.sub(_numTokens) ** 2 - 40 * numCoTokens.sub(_numTokens);
        return price * (1 ether)/200; //Can not use ** with rational numbers, thus we use 1/200
    }

    function mint(uint amount) public payable {
        require(buyPrice(amount) == msg.value, "Price does not match");
        _mint(msg.sender, amount);
        numCoTokens += amount;
    }

    function burn(uint amount) public onlyOwner {
        uint Value = sellPrice(amount);
        minter.transfer(Value);
        _burn(msg.sender, amount);
        numCoTokens = numCoTokens.sub(amount);
    }

    function destroy() public onlyOwner {
        require(balanceOf(owner()) == coSupply, "Owner does not have all the CoTokens");
        selfdestruct(msg.sender);
    }

    function numCO() public view returns (uint) {
        return numCoTokens;
    }

    function testgetBalance() public view returns (uint256) {
        return address(this).balance;
    }

}