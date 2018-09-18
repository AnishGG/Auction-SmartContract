pragma solidity ^0.4.24;

contract Auctioneer{

    /* this variable holds the address of the moderator which will run the bidding */
    address public moderator;

    /* m is the number of distinct items and q is a large prime number */
    uint public m, q;

    /* we will use unix timestamps to keep account of time*/
    /* Till this time all bidders who want to take part should be registered */
    uint inputDeadline;

    /* to check the number of bidders registering for the auction */
    uint num_bidders;

    /* To store all the winners among the Bidders */
    address public memory Winners = new uint[];

    /* This structure will represent each bidder in the game */
    struct Bidder{
        address account;
        /* For storing the item choices of a particular bidder */
        /* Two arrays of variable size in the memory */
        uint memory u = new uint[];
        uint memory v = new uint[];
        uint w_1, w_2;
    }

    /* For now any number of Bidders are allowed */
    Bidder[] public bidders;

    // ensures the call is made before certain time
    modifier onlyBefore(uint _time){
        require(now < _time, "Too Late"); _;
    }

    // ensures the call is made after certain time
    modifier onlyAfter(uint _time){
        require(now > _time, "Too early"); _;
    }

    // ensures only the moderator is calling the function
    modifier onlyModerator(){
        require(msg.sender == moderator, "Only Moderator is allowed to call this method"); _;
    }
    
    // ensures one of the Bidder is calling the function
    modifier isBidder(){
        bool is_bidder = false;
        for(uint i = 0;i < a.length; i++){
            if(msg.sender == bidders[i].account)
                is_bidder = true;
        }
        require(is_bidder, "You are not part of this auction"); _;
    }
    
    constructor(int num_items, int _q, uint inputTime){
        inputDeadline = inputTime;
        moderator = msg.sender;
        m = num_items;
        q = _q;
    }
}