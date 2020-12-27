// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;
import "./LoanPoolAave.sol";

contract LoanPoolFactory {
    uint256 public totalPools;
    address dai = 0x2f863ae298c24ecd542c7ee79dfd83c0225698c5;

    event NewLoanPool(
        uint256 id,
        address loanPool,
        uint256 collateralAmount,
        uint256 minimumBidAmount,
        uint256 auctionInterval,
        uint256 auctionDuration,
        uint8 maxParticipants,
        address tokenAddress,
        string lendingPool,
        address creator,
        uint256 createdAt
    );

    function addLoanPool(
        uint256 maximumBidAmount,
        uint256 minimumBidAmount,
        uint256 auctionInterval,
        uint256 auctionDuration,
        uint8 maxParticipants,
        address token
    ) public {
        address loanPool;

            LoanPoolAave newLoanPool = new LoanPoolAave(
                maximumBidAmount,
                minimumBidAmount,
                auctionInterval,
                auctionDuration,
                maxParticipants,
                token
            );
            loanPool = address(newLoanPool);
        
        }

        totalPools++;

        emit NewLoanPool(
            totalPools,
            loanPool,
            maximumBidAmount * maxParticipants,
            minimumBidAmount,
            auctionInterval,
            auctionDuration,
            maxParticipants,
            token,
            token == "Aave",
            msg.sender,
            block.timestamp
        );
    }
}
