// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract XRay {
    struct XRayRecord {
        uint256 nationalId;
        string imageUrl;
        string date;
    }

    mapping(uint256 => XRayRecord) public xrays;
    uint256 public xrayCount;

    event XRayAdded(uint256 nationalId, string imageUrl, string date);

    function addXRay(
        uint256 _nationalId,
        string memory _imageUrl,
        string memory _date
    ) public {
        xrayCount++;
        xrays[_nationalId] = XRayRecord(_nationalId, _imageUrl, _date);
        emit XRayAdded(_nationalId, _imageUrl, _date);
    }

    function getXRay(uint256 _nationalId) public view returns (
        uint256,
        string memory,
        string memory
    ) {
        XRayRecord memory xray = xrays[_nationalId];
        return (xray.nationalId, xray.imageUrl, xray.date);
    }
}