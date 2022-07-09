// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./Owned.sol";
import "./Logger.sol";
import "./IFaucet.sol";

contract Faucet is Owned, Logger ,IFaucet {
    // Think mapping as key-value pair.
    uint256 public numOfFunders;
    mapping(address => bool) public funders;
    mapping(uint256 => address) public lutfunders;

    modifier limitWithDraw(uint256 withDrawAmount) {
        require(
            withDrawAmount <= 100000000000000000,
            "Can't remove more than 0.1 ether"
        );
        _;
    }

    function addFunders() external payable {
        address funder = msg.sender;
        if (!funders[funder]) {
            uint256 index = numOfFunders++;
            funders[funder] = true;
            lutfunders[index] = funder;
        }
    }

    function withDraw(uint256 withDrawAmount)
        external
        limitWithDraw(withDrawAmount)
    {
        payable(msg.sender).transfer(withDrawAmount);
    }

    function getFunderAtIndex(uint256 index) external view returns (address) {
        return lutfunders[index];
    }

    function getAllFunders() external view returns (address[] memory) {
        address[] memory _funders = new address[](numOfFunders);
        for (uint256 i = 0; i < numOfFunders; i++) {
            _funders[i] = lutfunders[i];
        }
        return _funders;
    }
    function emitLog() public override pure returns(bytes32) {
        return "Hello World";
    }
    function test1() external isOwner {
        // some logic that only admin can do!
    }
}

// const instance = await Faucet.deployed()
// instance.addFunders({ from:accounts[8] , value:"510000000000000000"})
// instance.withDraw("1000000000000000000",{from:"0xbd1E9c0Da6D0D13f07Df720CeA98F2B4c0d73E62"})
