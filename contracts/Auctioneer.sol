pragma solidity ^0.4.24;

contract Auctioneer{

    /* this variable holds the address of the moderator which will run the bidding */
    address public moderator;

    /* m is the set of all distinct items and q is a large prime number */
    uint[] public m;
    uint public q;

    /* Time when contract is created */
    uint startTime;

    /* Time passed after initialisation of contract */
    function getcurrTime() public view returns(uint a){
        return now - startTime;
    }

    /* Till {startTime + notaryDeadline} all notaries who want to take part should be registered*/
    uint notaryDeadline;
    
    /* Till {startTime + bidderDeadline} all bidders who want to take part should be registered*/
    uint bidderDeadline;

    /* to check the number of bidders registering for the auction */
    uint num_bidders;

    /* To store all the winners among the Bidders */
    address[] public winners;

    /* This structure will represent each bidder in the game */
    struct Bidder{
        /* Address of Bidder */
        address account;

        /* Two arrays of variable size of type uint for storing item choices of bidder*/
        uint[] u;
        uint[] v;

        /* Two numbers w1 and w2 for representing W */
        uint w1;
        uint w2;
    }

    /* This structure will represent each notary in the game */
    struct Notary{
        address account;
    }
    
    /* For now any number of Bidders are allowed, but these must be kept private*/
    Bidder[] private bidders;

    /* For now any number of Notaries are allowed*/
    Notary[] public notaries;

    /* A map to store what all items are sold till now */
    mapping(uint => uint) is_sold;

    /* To check that only one bidder can register from one address */
    mapping (address => uint) private is_bidder;
    
    /* is_notary(x) = 0 means he is not a notary, is_notary(x) = 1 means he is a notary and not been assigned yet, is_notary(x) = $someAddress$ means this notary has been assigned to a bidder
    This mapping needs to be private because it contains information about the bidders address which implies it contains bidders interested items and it's value also. */
    mapping (address => address) private is_notary;
    
    /* Number of notaries which are not assigned yet */
    uint num_not_asgnd_notary = 0;
    
    // ensures the call is made before certain time
    modifier onlyBefore(uint _time){
        require(now - startTime < _time, "Too Late"); _;
    }

    // ensures the call is made after certain time
    modifier onlyAfter(uint _time){
        require(now - startTime > _time, "Too early"); _;
    }

    // ensures only the moderator is calling the function
    modifier onlyModerator(){
        require(msg.sender == moderator, "Only Moderator is allowed to call this method"); _;
    }
    
    // ensures one of the Bidder is calling the function
    modifier isBidder(){
        bool is_bidder_var = false;
        for(uint i = 0;i < bidders.length; i++){
            if(msg.sender == bidders[i].account)
                is_bidder_var = true;
        }
        require(is_bidder_var == true, "You are not part of this auction"); _;
    }
    
    /* You can call this event to check what all items are available for auction */
    event displayItems(uint[] m);
    
    /* Takes no of of items, prime number, Time after which notary registeration will close (measured from startTime),
    Time after which bidder registeration will close (measured from startTime), */
    constructor (uint _noofitems, uint _q, uint _notaryDeadline, uint _bidderDeadline) public{
        notaryDeadline = _notaryDeadline;
        bidderDeadline = _bidderDeadline;
        startTime = now;
        moderator = msg.sender;
        for(uint i = 0;i < _noofitems; i++){
            m.push(i+1);
        }
        q = _q;
        emit displayItems(m);
    }
    
    /* A public function which will register the notary iff one has not registered before */
    function registerNotary()
    public
    
    // allow registration of notaries only before the notaryDeadline
    onlyBefore(notaryDeadline)
    {
        require(is_notary[msg.sender] == 0, "Sorry, but you have already registered for this auction as a notary");
        is_notary[msg.sender] = 1;   // Means now this is present
        notaries.push(Notary({account:msg.sender}));
        num_not_asgnd_notary += 1;
    }
    
    /* A public function which will register the bidders, But here the one public address can place multiple bids*/
    function registerBidder(uint[] _u, uint[] _v, uint _w1, uint _w2)
    public
    
    // allow registration of bidders only before the bidderDeadline
    onlyBefore(bidderDeadline)
    {
        // For checking that the pair's array are equal in length
        require(_u.length == _v.length, "Wrong input format");
        bool is_item = false;
        for(uint i = 0;i < _u.length; i++){
            uint x = (_u[i] + _v[i])%q;
            is_item = false;
            for(uint j = 0;j < m.length; j++){
                if(x == m[j]){
                    is_item = true;
                    break;
                }
            }
            // All the items that the bidder is interested in, should be available in the set m
            require(is_item == true, "The items you sent are not correct");
        }
        /* Checking if the bidder has already registered */
        require(is_bidder[msg.sender] == 0, "Sorry, but you have already registered for this auction as a bidder");
        is_bidder[msg.sender] = 1;          // Add it to the map
        /* Assigning random notary to the bidder */
        require(assign_notary(Bidder({account:msg.sender, u:_u, v:_v, w1:_w1, w2:_w2})) == true, "No notaries are available");
        bidders.push(Bidder({account:msg.sender, u:_u, v:_v, w1:_w1, w2:_w2}));
    }
    
    /* A random number generator, returns number between zero and n*/
    function random(uint n) private view returns (uint8) {
        if(n == 0)
            return 0;
        return uint8(uint256(keccak256(block.timestamp, block.difficulty))%n);
    }
    
    /* A function to randomly assign a notary to a bidder */
    function assign_notary(Bidder _b) private returns (bool) {
        uint x = random(num_not_asgnd_notary);
        for(uint i = 1;i <= notaries.length; i++){
            if(is_notary[notaries[i-1].account] == 1){
                if(x == 0){
                    /* Handling the case where notary comes equal to the bidder */
                    if(notaries[i-1].account == _b.account){
                        if(num_not_asgnd_notary == 1)   return false;   // When only one notary is available and the bidder is also the nottary himself
                        i = 0;
                        x = random(num_not_asgnd_notary);
                    }
                    else{
                        is_notary[notaries[i-1].account] = _b.account;
                        return true;
                    }
                }
                else
                    x--;
            }
        }
        return false;
    }
    
    function auctioneer_sort() internal {
        if(bidders.length >= 2){
            sort(0, int(bidders.length - 1));
        }
    }
    
    function sort(int low, int high) internal {
        int i = low;
        int j = high;
        if(i == j)  return;
        Bidder storage pivot = bidders[uint(low + (high - low) / 2)];
        while(i <= j){
            while(compare(bidders[uint(i)], pivot) == false) i++;
            while(compare(pivot, bidders[uint(j)]) == false) j--; 
            // while(bidders[uint(i)] < pivot) i++;
            // while(pivot < bidders[uint(j)]) j--;
            if(i <= j){
                Bidder storage temp = bidders[uint(i)];
                bidders[uint(i)] = bidders[uint(j)];
                bidders[uint(j)] = temp;
                i++;
                j--;
            }
        }
        if(low < j){
            sort(low, j);
        }
        if(i < high){
            sort(i, high);
        }
    }
    
    function compare(Bidder x, Bidder y) internal view returns(bool){
        uint val1 = x.w1 - y.w1;
        uint val2 = x.w2 - y.w2;
        if(val1 + val2 == 0 || val1 + val2 < q/2){
            return true;    // x >= y
        }
        else
            return false;   // x < y
    }
    
    function find_winners() internal{
        for(uint i = 0;i < bidders.length; i++){
            bool is_winner = true;
            for(uint j = 0;j < bidders[i].u.length; j++){
                if(is_sold[(bidders[i].u[j] + bidders[i].u[j]) % q] != 0){
                    is_winner = false;
                    break;
                }
            }
            if(is_winner == true){
                winners.push(bidders[i].account);
                for(j = 0;j < bidders[i].u.length; j++){
                    is_sold[(bidders[i].u[j] + bidders[i].u[j]) % q] = 1;
                }
            }
        }
    }
}