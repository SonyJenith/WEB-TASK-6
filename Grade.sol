// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GradeBook {
    address public owner;
    Grade[] public grades;

    struct Grade {
        string studentName;
        string subject;
        uint256 grade;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addGrade(string memory _studentName, string memory _subject, uint256 _grade) public onlyOwner {
        grades.push(Grade(_studentName, _subject, _grade));
    }

    function updateGrade(uint256 _index, uint256 _newGrade) public onlyOwner {
        require(_index < grades.length, "Invalid index");
        grades[_index].grade = _newGrade;
    }

    function getGrade(string memory _studentName, string memory _subject) public view returns (uint256) {
        for (uint256 i = 0; i < grades.length; i++) {
            if (
                keccak256(abi.encodePacked(grades[i].studentName)) ==
                keccak256(abi.encodePacked(_studentName)) &&
                keccak256(abi.encodePacked(grades[i].subject)) ==
                keccak256(abi.encodePacked(_subject))
            ) {
                return grades[i].grade;
            }
        }
        return 0;
    }

    function averageGrade(string memory _subject) public view returns (uint256) {
        uint256 totalGrade = 0;
        uint256 count = 0;
        for (uint256 i = 0; i < grades.length; i++) {
            if (
                keccak256(abi.encodePacked(grades[i].subject)) ==
                keccak256(abi.encodePacked(_subject))
            ) {
                totalGrade += grades[i].grade;
                count++;
            }
        }
        if (count == 0) {
            return 0;
        }
        return totalGrade / count;
    }
}
