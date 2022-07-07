// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Faucet {
    address[] public funders;
    // External means that even other contracts and txs can call that 
    // function and these functions are part contract interface
    // This is a special even called when no function named is mentioned to call.
    receive() external payable {}
    function addfunds() external payable{
        funders.push(msg.sender);
    }
    // connect to ganache and get all funders
    function getAllfunders() public view returns(address[] memory) {
        return funders;
    }
    // connect to ganache and get funder at particular index.
    function getFunderAtIndex(uint8 index) external view returns(address) {
        address[] memory _funders = getAllfunders();
        return _funders[index];
    } 
}


// const instance = await Faucet.deployed()
