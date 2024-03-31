// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;
import "./CommitReveal.sol";

contract Lottery is CommitReveal {

    struct Player {
        address addr;
        uint choice;
        bool trasfer;
    }

    address public owner;
    uint public balance;
    bool public  Ownerchoice ;
    uint public  T1;
    uint public  T2;
    uint playernum = 5;
    uint state = 0;
    uint statetime ;
    uint numPlayer = 0;
    uint public  ownerchoice;

    mapping (uint => Player) public  player;
    


    constructor(uint _T1 , uint _T2) payable {
        owner = msg.sender;
        deposit(); // ทำการเรียกใช้ฟังก์ชัน deposit เพื่อฝาก ETH ที่ถูกส่งมาพร้อมกับการ deploy
        T1 = _T1;
        T2 = _T2;
    }

    // ฝาก ETH เข้าสู่ smart contract
    function deposit() public payable {
        require(msg.value == 3 ether, "Deposit amount must be greater than 0");
        balance += msg.value;
    }
    function selectOwner(uint choice) public payable  {
        require(choice >= 0 || choice <= 5);
        require(msg.sender == owner);
        statetime = block.timestamp;
        bytes32 Hashdata = getHash(bytes32(choice));
        commit(Hashdata);
        Ownerchoice = true;
    }
    function addplayer(uint choice) public payable {
        require(msg.value == 1 ether);
        require(Ownerchoice == true);
        require(choice >= 0 || choice <= 5);
        require(numPlayer < playernum);
        if(numPlayer == 0 ){
            player[numPlayer].addr = msg.sender;
            player[numPlayer].choice = choice;
        }else{
            for(uint i = 0 ; i < numPlayer ; i++){
                require(choice != player[i].choice);
            }
            player[numPlayer].addr = msg.sender;
            player[numPlayer].choice = choice;
        }
        numPlayer++;
        balance += msg.value;
    }
    function findWinder(uint choice) public  payable {
        require(msg.sender == owner);
        require(state == 2);
        reveal(bytes32(choice));
        ownerchoice = choice;
        for(uint i = 0 ; i <= numPlayer ; i++){
            if ( player[i].choice == choice){
                payable(player[i].addr).transfer(3 ether);
            }
        }
        state = 3;
    }
    function withdrawn() public  payable {
        for(uint i = 0 ; i < numPlayer ; i++){
            require(msg.sender == player[i].addr);
            require(player[i].trasfer == false);
            payable(msg.sender).transfer(1 ether);
            player[i].trasfer = true;
        }
    }
    modifier checkStageTransition() {
        if (block.timestamp > statetime + T1  ) {
            state = 2;
        }
        _;
    }
    // ถอน ETH จาก smart contract
}
