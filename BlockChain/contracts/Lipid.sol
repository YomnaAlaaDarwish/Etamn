// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract Lipid {
    struct LipidReport {
        uint256 nationalId;
        uint256 labId;
        string imageUrl;
        string status;
        uint256 cholesterolTotal;
        uint256 triglycerides;
        uint256 hdlCholesterol;
        uint256 ldlCholesterol;
        string date;
    }

    mapping(uint256 => LipidReport[]) private lipidReports;

    event ReportAdded(
        uint256 indexed nationalId,
        uint256 labId,
        string imageUrl,
        string status,
        uint256 cholesterolTotal,
        uint256 triglycerides,
        uint256 hdlCholesterol,
        uint256 ldlCholesterol,
        string date
    );

    function addReport(
        uint256 _nationalId,
        uint256 _labId,
        string memory _imageUrl,
        string memory _status,
        uint256 _cholesterolTotal,
        uint256 _triglycerides,
        uint256 _hdlCholesterol,
        uint256 _ldlCholesterol,
        string memory _date
    ) public {
        LipidReport memory newReport = LipidReport({
            nationalId: _nationalId,
            labId: _labId,
            imageUrl: _imageUrl,
            status: _status,
            cholesterolTotal: _cholesterolTotal,
            triglycerides: _triglycerides,
            hdlCholesterol: _hdlCholesterol,
            ldlCholesterol: _ldlCholesterol,
            date: _date
        });

        lipidReports[_nationalId].push(newReport);

        emit ReportAdded(
            _nationalId,
            _labId,
            _imageUrl,
            _status,
            _cholesterolTotal,
            _triglycerides,
            _hdlCholesterol,
            _ldlCholesterol,
            _date
        );
    }

    function getReportsByNationalId(uint256 _nationalId)
        public
        view
        returns (LipidReport[] memory)
    {
        return lipidReports[_nationalId];
    }
}
