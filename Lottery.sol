// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;
import "./CommitReveal.sol";


contract Lottery is CommitReveal{

    struct Player {
        uint choice;
        bool legal;
        address addr;
        uint timestamps;
        bool withdrawn;
    }

    address public  owner;

    uint public balance = 0;
    uint public N ;
    uint public numPlayer = 0;
    uint public state = 1;
    uint public T1; 
    uint public T2 ;
    uint public T3 ;
    uint public statetime = 0 ;
    uint public findwinner = 0;
    uint public countlegal = 0;
    address  public  winneradresss;

    mapping (uint => Player) public  player;
    mapping (address => uint) public playernumber;

    constructor(uint _T1,uint _T2 , uint _T3,uint _N){
        owner = payable(msg.sender);
        T1 = _T1;
        T2 = _T2;
        T3 = _T3;
        N = _N;
         //adress person who deploy
    }


    function enter(uint choice) public payable checkStageTransition{
            require(state == 1 , "state not matach" );
            require(msg.sender != owner);
            require(msg.value == 1000000000000000000 wei , "Bet 0.0001 ETH");
            require(numPlayer < N , "Max players ") ;
            for(uint i = 0 ; i <= numPlayer ; i++){
                require(player[i].addr != msg.sender , "You are already register");
            }
            balance += 1 ether;
            playernumber[msg.sender] = numPlayer;
            player[numPlayer].addr = msg.sender;
            player[numPlayer].timestamps = block.timestamp;
            player[numPlayer].legal = false;
            player[numPlayer].withdrawn = false;
            // ใส่ค่าถูกกดไหม?
            if(numPlayer == 0 ){
                statetime = block.timestamp;
            }
            // commit ค่าไปเลย
            bytes32 Hashdata = getHash(bytes32(choice));
            commit(Hashdata);
            numPlayer++;
            // จับเวลา

            //adress of player entering to loterry
            // add payable adress to players
    }

    function Review(uint choice) public checkStageTransition{
        require(state == 2 , "Not in state 2");
        reveal(bytes32(choice));
        uint idx  = playernumber[msg.sender];
        if (choice >=  0 || choice <= 999){
            player[idx].legal = true;
            player[idx].choice = choice;
        }
    }
    // ไม่เข้าใจหลักการ Hash ทำไม hash ได้ 0 ตลอด
    function FindWinnder() public payable   checkStage3{
        require( msg.sender == owner ,"You are not owner");
        require(state == 3 , " Not In state 3");
        //xor หา คนชนะ
        uint numlegal = 0;
        uint resualt  = 0;
        for (uint i = 0 ; i <= numPlayer ; i++){
            if (player[i].legal == true){
                resualt = resualt ^ player[i].choice;
                numlegal++;
            }
        }
        if (numlegal == 0){
            payable(owner).transfer(numPlayer * 1 ether);
        }else{
            uint hash = uint(keccak256((abi.encodePacked(resualt))));
            uint winnerindex = hash % numlegal;
            uint i = 0 ;
            while(countlegal != winnerindex+1){
                if(player[i].legal == true){
                    countlegal++;
                }
                i++;
            }
            address payable winner = payable (player[i].addr);
            winneradresss = winner;
            uint prize = numPlayer * 1 ether * 98 / 100;
            winner.transfer(prize);
            payable(owner).transfer(numPlayer * 1 ether * 2 / 100);
        }
        findwinner =1;
    }

    function PayBack() public payable checkStage4{
        require(state == 4 &&   findwinner == 0 ," Not In state 4");
        uint idx = playernumber[msg.sender];
        require(msg.sender == player[idx].addr , " You not player");
        require(player[idx].withdrawn == false , "You already withdrawn");
        player[idx].withdrawn = true;
        balance -= 1 ether;
        payable(msg.sender).transfer(1 ether);
    }

    modifier checkStageTransition() {
        if (block.timestamp > statetime + T1 && statetime != 0 && state == 1 ) {
            state = 2;
        }
        _;
    }
    modifier  checkStage3(){
        if(block.timestamp > statetime + T1 + T2){
            state = 3;
        }
        _;
    }
    modifier  checkStage4(){
        if(block.timestamp > statetime + T1 + T2 +T3  ){
            state = 4;
        }
        _;
    }
    // function getRandomNumber() public  view  returns (uint) {
    //     return uint(keccak256(abi.encodePacked(owner,block.timestamp)));
    // }
}