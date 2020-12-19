// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

contract Collect {
    address Collector;

    function collateralView() public view returns(address){
        return Collector;
    }

}