// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery
{
    address public admin;
    address payable[] public participants;
    uint256 public receivedAmount;

//Constructor
//================================================
    constructor ()
    {
        admin = msg.sender;
    }
//================================================

//Modifiers
//============================================

    //Checks whether the sender has sent enough fund or not
    modifier hasMinFund 
    {
        require(msg.value >= 10 wei, "Minimum 1 ETH should be sent");
        _;
    }

    //Checks whether the user is admin or not
    modifier isAdmin
    {
        require(msg.sender == admin, "Auth failed, only admin can perform this task");
        _;
    }

    modifier hasEnoughParticipants
    {
        require(participants.length >= 3, "Not enough participants");
        _;
    }
//==============================================

//Payable receive function
//===============================================
    receive() payable external hasMinFund {
        participants.push(payable(msg.sender));
        receivedAmount= msg.value;
    }
//===============================================

// Custom lottery functions
//====================================================================
    //function to generate a random number
   function random() public view returns(uint)
   {
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
   } 

    //function to get the contract balance
   function getContractBalance() isAdmin public view returns(uint) 
   {
       return address(this).balance;
   } 

   function selectWinner() isAdmin hasEnoughParticipants public returns(address)
   {
       uint randomNumber = random() % participants.length;
       address payable winner = participants[randomNumber];
       winner.transfer(getContractBalance());
       return winner;
   }
//============================================================================

}