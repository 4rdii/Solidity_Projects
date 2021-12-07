// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Storage {

    struct People{
        uint256 favnumber;
        string name;
    }

    People[] public peoples; 
    mapping(string => uint256) public nametonumber;

    function PeopleReciver(string memory _name , uint256 _favnumber) public{
        peoples.push(People(_favnumber, _name));
        nametonumber[_name] = _favnumber;
    }
    function retrieve(string memory _name) public view returns(uint256){
        return nametonumber[_name];
    }
}