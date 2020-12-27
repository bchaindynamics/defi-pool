// SPDX-License-Identifier: MIT
pragma solidity 0.7.3;
import "./AavePooledLoan.sol";

contract LoanPoolFactory {
    uint256 public totalPools;
    address dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    event LoanPoolNew(
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

    function addPoolLoan(
        uint256 maximumBidAmount,
        uint256 minimumBidAmount,
        uint256 auctionInterval,
        uint256 auctionDuration,
        uint8 maxParticipants,
        address token
    ) public {
        address loanPool;

            PoolLoanAave newLoanPool = new PoolLoanAave(
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
            "0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9",
            msg.sender,
            block.timestamp
        );
    }
}
