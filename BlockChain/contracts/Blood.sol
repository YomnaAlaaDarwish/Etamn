// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Blood {
    struct BloodReport {
        uint256 nationalId;
        uint256 labId;
        string imageUrl;
        string status;
        uint256 haemoglobin;
        uint256 haematocrit;
        uint256 rbcs;
        string date;
    }

    BloodReport[] public reports;

    function addReport(
        uint256 _nationalId,
        uint256 _labId,
        string memory _imageUrl,
        string memory _status,
        uint256 _haemoglobin,
        uint256 _haematocrit,
        uint256 _rbcs,
        string memory _date
    ) public {
        BloodReport memory newReport = BloodReport({
            nationalId: _nationalId,
            labId: _labId,
            imageUrl: _imageUrl,
            status: _status,
            haemoglobin: _haemoglobin,
            haematocrit: _haematocrit,
            rbcs: _rbcs,
            date: _date
        });

        reports.push(newReport);
    }

    function getReport(uint256 index) public view returns (BloodReport memory) {
        require(index < reports.length, "Index out of bounds");
        return reports[index];
    }

    function getAllReports() public view returns (BloodReport[] memory) {
        return reports;
    }
}