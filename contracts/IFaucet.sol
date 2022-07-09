// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0; 


interface IFaucet {
    function addFunders() external payable;
    function withDraw(uint withDrawAmount) external;
}