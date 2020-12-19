// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import './Collector.sol';

contract Factory1 is Collect{
    uint public loanAmount;
    uint public loanAmountLeft;
    uint public minBid;
    uint public minIntrestRate;
    uint public maxIntrestRate;
    uint public totalParticipants;
    uint public poolStartTime;
    uint public participationTime;
    uint public claimLoanTime;
    uint public BidAmount;
    uint public newBid;
    uint public loanNeedOfBorrower;
    uint public collateral;
    uint public totalBid;
    uint public claimAmount;
    uint public intrestRateonLoan;
    uint public payBackAmount;
    uint public intrestRate;
    uint public returnCollateral;
    uint public collateralIntrestrate;
    bool public bidDecision;
    bool public poolDecision;
    address internal borrowersAdd;
    address internal lendersAdd;
    address internal highestBiddersAdd;
    
    //mappings
    mapping (address => bool) public isParticipant;
    mapping (address => bool) public highestBidder;
    mapping (address => bool) public againParticipate;
    mapping (address => bool) public lender;
    mapping (address => bool) public borrower;

    //events
    event NewParticipant(address loanPool, address participant, uint amount);

    event bid(
        address loanPool,
        address borrower,
        uint amount
    );

    event newBidAmount(
        address loanPool,
        address borrower,
        uint amount
    );

    event giveLoan(
        address loanPool,
        address claimer,
        address sender,
        uint amount
    );

    event giveCollateral( 
        address loanPool,
        address borrower,
        uint amount
    );

    event returnLoanAmountToLender(
        address loanPool,
        address receiver,
        uint amount
    );

    event returnLoanAmount(
        address loanPool,
        address sender,
        address lender,
        uint amount
    );


    //constructor
    constructor (
        uint _loanAmount,
        uint _minBid,
        uint _maxIntrestRate,
        uint _minIntrestRate
    ) {
        loanAmount = _loanAmount;
        minBid = _minBid;
        maxIntrestRate = _maxIntrestRate;
        minIntrestRate = _minIntrestRate;
        poolStartTime = block.timestamp;
    }

    /*
    The borrowers param should be set fist in order to let them in pool;
     */

    function BorrowersParam(uint _loanNeedOfBorrower, uint _collateral) public {
        require(_loanNeedOfBorrower <= loanAmount, "You can't have what you can't");
        loanNeedOfBorrower = _loanNeedOfBorrower;
        collateral = _collateral;
    }


    /*
    *First the contract should allow borrowers to participate in the pool.
    *Just at the time of borrower entering pool the selected collateral should be 
    transferred to the pool's address.
     */
    function Participate() public {
        // BasicRequirements();
        BorrowersParam(loanNeedOfBorrower , collateral);
        require(loanNeedOfBorrower <= loanAmount);
        require(collateral > 0);
        isParticipant[msg.sender] = true;
        totalParticipants = totalParticipants++;
        participationTime = block.timestamp;
        emit NewParticipant(Collector, msg.sender, collateral); //Collateral is being deposited in another contract;
    }

    /*
    *After the borrower has participated in the pool, he/she should be able to bid 
    for th loan. 
     */
    function Bid(uint _bid) public {
        require(_bid > minBid);
        require(collateral > 0);
        require(!highestBidder[msg.sender]);
        BidAmount = _bid;
        emit bid(
            Collector,
            borrowersAdd,
            BidAmount
        );
        
    }

    /*
    * If the borrower isn't the highest bidder and he/she wants to bid again
    to become the higgest bidder, they will be able to do it
    */
    function Bidagain(uint _newAmount, bool _bidDecision) public {
        require(bidDecision == true);

        newBid = _newAmount; //The borrower sets the new bid amount 

        bidDecision = _bidDecision; //The borrower decide if he/she wants to bid again or not

        // This will allow users to bid again if they wish to and restrict highest bidder to accidently bid again.
        if(bidDecision == true && !highestBidder[msg.sender]) {
            emit newBidAmount(
                address(this),
                borrowersAdd,
                newBid
            );
        } else if (bidDecision == false && !highestBidder[msg.sender]) {
            return ;
        } else {
            return ;
        }
        totalBid = BidAmount + newBid;
    } 

    /*
    *Allowing the lender to decide what should be the intrestrate;
    * Note:- this is hard coded and currently it has nothing to do with credit score!
     */
    function IntrestRate(uint _intrestRate , uint _collateralIntrestrate) public {
        intrestRate = _intrestRate;
        collateralIntrestrate = _collateralIntrestrate;
    }


    /*
    * After deciding who is the highestBidder we will let borrower decide what the 
    intrestrate should be depending upon the credit score of the user.
    * The borrower can either take the entire loan or some amount of loan
    *Note:- Instead of creating another function for giving back the collateral, I'm 
            adding that event here itself in order to give back the collateral same time 
            to that of giving loan!
    *Note:- Intrest rate value on collateral is hard coded and any maths is not taking place
            here as of now!
    */
    function claimLoan() public {
        require(isParticipant[msg.sender]);
        claimAmount = loanNeedOfBorrower;
        claimLoanTime = block.timestamp;
        
        loanAmountLeft = loanAmount - loanNeedOfBorrower;

        returnCollateral = collateral + collateralIntrestrate;
        
        emit giveLoan(
            address(this),
            highestBiddersAdd,
            lendersAdd,
            loanNeedOfBorrower
        );

        if(!highestBidder[msg.sender]) {
            emit giveCollateral(
                Collector,
                borrowersAdd,
                returnCollateral
                );
        } 
    }

    /*
    *If there is some tokens left in the pool, we will restart the pool with the remaning 
    tokens. 
    *Note:- that lender has the option to take all his/her remining tokens if they wish so!
     */
    function continuePool(bool _poolDecision) public {
        require(lender[msg.sender]);
        require(!borrower[msg.sender]);

        poolDecision = _poolDecision;

        // lendersAdd = ;

        if(poolDecision == true) {
            Bid(BidAmount);
            claimLoan();
        } else {
            emit returnLoanAmountToLender(
                Collector,
                lendersAdd,
                loanAmountLeft
            );
        }
    } 

    /*
    *Once the loan is claimed, the user also has to pay back to the lender.
    *Note that in this function I'm not enabling features such as EMI, as of now just -
    normal payback with the decided intrest rate.
    */

    function payBackLoan() public {
        intrestRateonLoan = intrestRate / 100 * loanAmount;
        payBackAmount = claimAmount + intrestRateonLoan;
        emit returnLoanAmount(
            Collector,
            highestBiddersAdd,
            lendersAdd,
            payBackAmount
        );
    } 
}