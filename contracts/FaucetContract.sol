// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Faucet {
    // Think mapping as key-value pair.
    uint public numOfFunders;
    mapping (uint => address) public funders;
    
    function addFunders() external payable {
        uint index = numOfFunders++;
        funders[index] = msg.sender;
    }
    function getFunderAtIndex(uint index) external view returns(address) {
       return funders[index];
    }
    function getAllFunders() external view returns(address[] memory) {
        address [] memory _funders = new address[](numOfFunders);
        for(uint i = 0; i < numOfFunders; i++) {
          _funders[i] = funders[i];
        }
        return _funders;
    }

}

// const instance = await Faucet.deployed()
// instance.addFunders({ from:accounts[8] , value:"25000000000000000000"})
