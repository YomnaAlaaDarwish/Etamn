// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract Prescription {
    struct PrescriptionRecord {
        uint256 nationalId;
        string imageUrl;
        string date;
    }

    mapping(uint256 => PrescriptionRecord[]) private prescriptions;

    event PrescriptionAdded(
        uint256 indexed nationalId,
        string imageUrl,
        string date
    );

    function addPrescription(
        uint256 _nationalId,
        string memory _imageUrl,
        string memory _date
    ) public {
        PrescriptionRecord memory newPrescription = PrescriptionRecord({
            nationalId: _nationalId,
            imageUrl: _imageUrl,
            date: _date
        });

        prescriptions[_nationalId].push(newPrescription);

        emit PrescriptionAdded(_nationalId, _imageUrl, _date);
    }

    function getPrescriptionsByNationalId(uint256 _nationalId)
        public
        view
        returns (PrescriptionRecord[] memory)
    {
        return prescriptions[_nationalId];
    }
}