pragma solidity ^0.4.24;

contract Auctioneer{

    /* this variable holds the address of the moderator which will run the bidding */
    address public moderator;

    /* m is the set of all distinct items and q is a large prime number */
    uint[] public m;
    uint public q;

    /* we will use unix timestamps to keep account of time*/
    /* Till this time all bidders who want to take part should be registered */
    uint inputDeadline;

    /* to check the number of bidders registering for the auction */
    uint num_bidders;

    /* To store all the winners among the Bidders */
    address[] public Winners;

    /* This structure will represent each bidder in the game */
    struct Bidder{
        address account;
        /* For storing the item choices of a particular bidder */
        /* Two arrays of variable size in the memory */
        uint[] u;
        uint[] v;
        uint w_1;
        uint w_2;
    }
    
    /* For now any number of Bidders are allowed */
    Bidder[] public bidders;
    
    /* This structure will represent each notary in the game */
    struct Notary{
        address account;
    }
    Notary[] public notaries;
    mapping (address => uint) is_notary;
    

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
        for(uint i = 0;i < bidders.length; i++){
            if(msg.sender == bidders[i].account)
                is_bidder = true;
        }
        require(is_bidder == true, "You are not part of this auction"); _;
    }
    
    /* You can call this event to check what all items are available for auction */
    event displayItems(uint[] m);
    
    /* 27/06/2019 04:00:00 -> unix time stamp = 1561608000 */
    constructor (uint[] _items, uint _q, uint _inputTime) public{
        inputDeadline = _inputTime;
        moderator = msg.sender;
        m = _items;
        q = _q;
    }
    
    /* A public function which will register the notary iff one has not registered before */
    function registerNotary()
    public
    
    // allow registration of notaries only before the inputDeadline
    onlyBefore(inputDeadline)
    {
        require(is_notary[msg.sender] == 0, "Sorry, but you have already registered for this auction");
        is_notary[msg.sender] = 1;   // Means now this is present
        notaries.push(Notary({account:msg.sender}));
    }
}