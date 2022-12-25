// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;
import "./SimpleStorage.sol";

contract StorageFactory is SimpleStorage {

    SimpleStorage[] public simpleStorageArray;

    function createSimplyStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageFavoriteNumber) public {

        // Address
        // ABI

        SimpleStorage extContract = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        extContract.store(_simpleStorageFavoriteNumber);

    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) {

        // // Retrieve
        // SimpleStorage extContract = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        // return extContract.retrieve();

        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();

    }
}
