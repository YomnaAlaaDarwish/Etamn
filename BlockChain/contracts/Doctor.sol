// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Doctor {
    struct DoctorRecord {
        uint256 nationalId;
        string name;
        string dateOfBirth;
        string email;
        string password;
        string certificateHash;
    }

    mapping(uint256 => DoctorRecord) public doctors;
    uint256 public doctorCount;

    event DoctorAdded(uint256 nationalId, string name, string email);

    function addDoctor(
        uint256 _nationalId,
        string memory _name,
        string memory _dateOfBirth,
        string memory _email,
        string memory _password,
        string memory _certificateHash
    ) public {
        doctorCount++;
        doctors[_nationalId] = DoctorRecord(_nationalId, _name, _dateOfBirth, _email, _password, _certificateHash);
        emit DoctorAdded(_nationalId, _name, _email);
    }

    function getDoctor(uint256 _nationalId) public view returns (
        uint256,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory
    ) {
        DoctorRecord memory doctor = doctors[_nationalId];
        return (doctor.nationalId, doctor.name, doctor.dateOfBirth, doctor.email, doctor.password, doctor.certificateHash);
    }
}