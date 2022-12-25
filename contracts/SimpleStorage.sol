// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {

    // This will get initialized to zero
    uint256 favoriteNumber;
    bool favoriteBool;

    // Structures
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // Lists
    People[] public people;

    // Mapping
    mapping(string => uint256) public nameToFavoriteNumber;

    // Functions
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    // Add a person to the People List
    // Memory means that after execution it will dissappear
    // We need this for the string because it exists in the memory
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

}