// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract EscrowDataStorage {
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
    
    struct Data {
        string date;
        uint id;
        string contractName;
        address sender;
        address receiver;
        uint amount;
        string deadline;
    }

    Data[] private data;

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
    
    function addData(string memory _date, string memory _contractName, address _sender, address _receiver, uint _amount$, string memory _deadline) public returns (bool) {
        require(_sender != address(0), "Sender address cannot be zero");
        require(_receiver != address(0), "Receiver address cannot be zero");
        require(_amount$ > 0, "Amount must be greater than zero");

        uint id = data.length;
        data.push(Data({
            date: _date,
            id: id,
            contractName: _contractName,
            sender: _sender,
            receiver: _receiver,
            amount: _amount$,
            deadline: _deadline
        }));

        return true;
    }

    function getDataCount() public view returns (uint) {
        return data.length;
    }

     function getData(uint _index) public view returns (string memory, uint, string memory, address, address, uint, string memory) {
        require(_index < data.length, "Index out of range");

        Data memory d = data[_index];
        return (d.date, d.id, d.contractName, d.sender, d.receiver, d.amount, d.deadline);
    }
}
