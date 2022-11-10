//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract SuperchatDapp {
    uint256 private messageCounter = 0;

    struct Message {
        uint256 messageId;
        address sender;
        string body;
        uint256 created;
        uint256 updated;
        bool isDeleted;
    }

    mapping(uint256 => address) createdBy;

    Message[] messages;

    event Action(
        string indexed action,
        address indexed sender,
        string body,
        uint256 updated
    );

    function createMessage(string memory _body) public {
        messages.push(
            Message(
                messageCounter,
                msg.sender,
                _body,
                block.timestamp,
                block.timestamp,
                false
            )
        );
        createdBy[messageCounter] = msg.sender;
        emit Action("New message", msg.sender, _body, block.timestamp);
        messageCounter++;
    }

    function updateMessage(uint256 _messageId, string memory _newBody) public {
        require(
            msg.sender == createdBy[_messageId],
            "You are not the creator of the message"
        );

        for (uint256 i = 0; i < messageCounter; i++) {
            if (messages[i].messageId == _messageId) {
                messages[i].body = _newBody;
            }
        }

        emit Action("Update message", msg.sender, _newBody, block.timestamp);
    }

    function deleteMessage(uint256 _messageId) public {
        require(
            msg.sender == createdBy[_messageId],
            "You are not the creator of the message"
        );

        for (uint256 i = 0; i < messageCounter; i++) {
            if (messages[i].messageId == _messageId) {
                messages[i].isDeleted = true;
            }
        }

        emit Action(
            "Delete message",
            msg.sender,
            "Deleted Message",
            block.timestamp
        );
    }

    function getMessages() public view returns (Message[] memory) {
        return messages;
    }
}
