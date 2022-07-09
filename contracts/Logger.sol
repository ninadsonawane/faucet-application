// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0; 

// Abstract Contract
// Its for designers to say that any child of abstract contract has to implement
// specified methods!
abstract contract Logger {
  uint public testNum;
  constructor () {
    testNum = 100;
  }
  function emitLog() public pure virtual returns(bytes32);
  function test3() public pure returns(uint) {
    return 100;
  }
}