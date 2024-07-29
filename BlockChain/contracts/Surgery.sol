// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Surgery {
    struct SurgeryRecord {
        uint256 nationalId;
        string imageUrl;
        string date;
    }

    mapping(uint256 => SurgeryRecord) public surgeries;
    uint256 public surgeryCount;

    event SurgeryAdded(uint256 nationalId, string imageUrl, string date);

    function addSurgery(
        uint256 _nationalId,
        string memory _imageUrl,
        string memory _date
    ) public {
        surgeryCount++;
        surgeries[_nationalId] = SurgeryRecord(_nationalId, _imageUrl, _date);
        emit SurgeryAdded(_nationalId, _imageUrl, _date);
    }

    function getSurgery(uint256 _nationalId) public view returns (
        uint256,
        string memory,
        string memory
    ) {
        SurgeryRecord memory surgery = surgeries[_nationalId];
        return (surgery.nationalId, surgery.imageUrl, surgery.date);
    }
}