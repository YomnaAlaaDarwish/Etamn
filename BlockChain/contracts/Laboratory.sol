// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Laboratory {
    struct LaboratoryRecord {
        string name;
        string imageHash;
        string email;
        string password;
    }

    mapping(uint256 => LaboratoryRecord) public laboratories;
    uint256 public laboratoryCount;

    event LaboratoryAdded(string name, string imageHash, string email, string password);

    function addLaboratory(
        string memory _name,
        string memory _imageHash,
        string memory _email,
        string memory _password
    ) public {
        laboratoryCount++;
        laboratories[laboratoryCount] = LaboratoryRecord(_name, _imageHash, _email, _password);
        emit LaboratoryAdded(_name, _imageHash, _email, _password);
    }

    function getLaboratory(uint256 _index) public view returns (
        string memory,
        string memory,
        string memory,
        string memory
    ) {
        LaboratoryRecord memory laboratory = laboratories[_index];
        return (laboratory.name, laboratory.imageHash, laboratory.email, laboratory.password);
    }
}