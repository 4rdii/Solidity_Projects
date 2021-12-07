// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./Storage.sol";

contract StorageFactory is Storage{

    Storage[] public StorageArray; 
    // creating a contract from another contract
    function creatStorageContract() public{
        Storage storage1 = new Storage();
        StorageArray.push(storage1);

    }
    // calling functions from other contracts
    function sfStore(uint256 _StorageIndex, string memory _name, uint256 _favnumber) public{
        Storage storage1 = Storage(address(StorageArray[_StorageIndex]));
        storage1.PeopleReciver(_name, _favnumber);
    }
    function sfGet(uint256 _StorageIndex, string memory _name) public view returns(uint256){
        Storage storage1 = Storage(address(StorageArray[_StorageIndex]));
        return storage1.retrieve(_name) ;
    }
}