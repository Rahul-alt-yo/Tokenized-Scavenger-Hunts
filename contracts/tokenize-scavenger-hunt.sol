
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EducationalScavengerHunt {

    // Event to log when a participant solves a clue
    event ClueSolved(address participant, uint256 clueIndex);

    // Struct to represent each clue
    struct Clue {
        string question;
        bytes32 answerHash;
        bool isActive;
    }

    // List of clues
    Clue[] public clues;

    // Mapping to track which clues each participant has solved
    mapping(address => mapping(uint256 => bool)) public participantProgress;

    // Function to add a new clue (only the contract owner can add clues)
    function addClue(string memory _question, string memory _answer) public {
        bytes32 answerHash = keccak256(abi.encodePacked(_answer));
        clues.push(Clue({
            question: _question,
            answerHash: answerHash,
            isActive: true
        }));
    }

    // Function to deactivate a clue (only the contract owner can deactivate clues)
    function deactivateClue(uint256 _clueIndex) public {
        require(_clueIndex < clues.length, "Clue does not exist.");
        clues[_clueIndex].isActive = false;
    }

    // Function to solve a clue
    function solveClue(uint256 _clueIndex, string memory _answer) public {
        require(_clueIndex < clues.length, "Clue does not exist.");
        require(clues[_clueIndex].isActive, "Clue is not active.");
        require(!participantProgress[msg.sender][_clueIndex], "Clue already solved by participant.");

        // Check if the provided answer is correct
        bytes32 answerHash = keccak256(abi.encodePacked(_answer));
        require(answerHash == clues[_clueIndex].answerHash, "Incorrect answer.");

        // Mark the clue as solved for the participant
        participantProgress[msg.sender][_clueIndex] = true;

        // Emit an event to log that the participant solved the clue
        emit ClueSolved(msg.sender, _clueIndex);

        // Logic to reward the participant with a token can be added here (ERC20 or ERC721)
        // For example: mint(msg.sender);
    }

    // Function to get the number of clues
    function getNumberOfClues() public view returns (uint256) {
        return clues.length;
    }

    // Function to check if a participant has solved a specific clue
    function hasSolvedClue(address _participant, uint256 _clueIndex) public view returns (bool) {
        require(_clueIndex < clues.length, "Clue does not exist.");
        return participantProgress[_participant][_clueIndex];
    }
}
