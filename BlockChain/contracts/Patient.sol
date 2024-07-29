// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Patient {
    struct PatientRecord {
        uint256 nationalId;
        string name;
        string dateOfBirth;
        string email;
        string password;
        string hasSurgeriesBefore;
    }

    mapping(uint256 => PatientRecord) public patientRecords;
    uint256 public patientCount;

    event PatientAdded(
        uint256 nationalId,
        string name,
        string dateOfBirth,
        string email,
        string password,
        string hasSurgeriesBefore
    );

    function addPatient(
        uint256 _nationalId,
        string memory _name,
        string memory _dateOfBirth,
        string memory _email,
        string memory _password,
        string memory _hasSurgeriesBefore
    ) public {
        patientCount++;
        patientRecords[_nationalId] = PatientRecord(
            _nationalId,
            _name,
            _dateOfBirth,
            _email,
            _password,
            _hasSurgeriesBefore
        );
        emit PatientAdded(
            _nationalId,
            _name,
            _dateOfBirth,
            _email,
            _password,
            _hasSurgeriesBefore
        );
    }

    function getPatient(uint256 _nationalId) public view returns (
        uint256,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory
    ) {
        PatientRecord memory patient = patientRecords[_nationalId];
        return (
            patient.nationalId,
            patient.name,
            patient.dateOfBirth,
            patient.email,
            patient.password,
            patient.hasSurgeriesBefore
        );
    }
}



