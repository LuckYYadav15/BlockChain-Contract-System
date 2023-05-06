//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    address payable public buyer;
    address payable public seller;
    uint public advancePayment;
    uint public fullPayment;
    uint public deliveryConfirmationTime;
    bool public isPaid;
    bool public isDelivered;
    bool public isDeliveryConfirmed;
    bool public contractcomplete;
    bool public withdraw_status_advance;
    bool public withdraw_status_full;
    
    constructor(address payable _buyer, address payable _seller, uint _advancePayment, uint _fullPayment) {
        buyer = _buyer;
        seller = _seller;
        advancePayment = _advancePayment;
        fullPayment = _fullPayment;
        contractcomplete = false;
        withdraw_status_advance = false;
        withdraw_status_full = false;
    }
    
    function makeAdvancePayment() external payable {
        require(msg.sender == buyer, "Only buyer can make an advance payment");
        require(msg.value == advancePayment, "Advance payment amount is incorrect");
        require(!contractcomplete, "Contract has been completed");
        isPaid = true;
        seller.transfer(msg.value);
    }
    
    function confirmDelivery() external {
        require(msg.sender == buyer, "Only buyer can confirm delivery");
        require(isPaid, "Advance payment has not been made yet");
        require(!isDelivered, "Delivery has already been confirmed");
        deliveryConfirmationTime = block.timestamp;
        isDelivered = true;
    }
    
    function makeFullPayment() external payable {
        require(msg.sender == buyer, "Only buyer can make the full payment");
        require(msg.value == fullPayment - advancePayment, "Full payment amount is incorrect");
        require(isDelivered, "Delivery has not been confirmed yet");
        isDeliveryConfirmed = true;
        seller.transfer(msg.value);
        contractcomplete = true;
    }
    
    function withdraw_advance() external {
        require(msg.sender == seller, "Only seller can withdraw funds");
        require(isPaid, "Advance payment has not been made yet");
        require(!withdraw_status_advance, "Advance Payment has been withdrawn");
        seller.transfer(address(this).balance);
        withdraw_status_advance = true;
    }
    function withdraw_full() external {
        require(msg.sender == seller, "Only seller can withdraw funds");
        require(isDeliveryConfirmed, "Full payment has not been made yet");
        require(!withdraw_status_full, "Full Payment has been withdrawn");
        seller.transfer(address(this).balance);
        withdraw_status_full = true;
    }
}