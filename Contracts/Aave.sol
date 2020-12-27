pragma solidity >=0.4.22 <0.8.0;

import "./interface/IERC20.sol";

contract Aave {
    address internal tokenAddress;
    address internal aTokenAddress;
    address internal lendingPoolAddress;
    address internal lendingPoolCoreAddress;

    constructor() public {
        tokenAddress = 0x6b175474e89094c44da98b954eedeac495271d0f;
        aTokenAddress = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
        lendingPoolAddress = 0x5c94e75316CAD5f5e0eF2E8A460Bd4aBAd6222Ee;
        lendingPoolCoreAddress = 0x7BF52810F9Ff7F13c99F12D5512e840850eDb3b2;
    }

    receive() external payable {}

    function getLendingRate() public view returns (uint256) {
        return
            IAaveLendingPoolCore(lendingPoolCoreAddress)
                .getReserveCurrentLiquidityRate(tokenAddress);
    }

    function getBorrowRate() public view returns (uint256) {
        return
            IAaveLendingPoolCore(lendingPoolCoreAddress)
                .getReserveCurrentStableBorrowRate(tokenAddress);
    }
    function deposit(uint256 amount) internal returns (bool) {
        IERC20(tokenAddress).approve(lendingPoolCoreAddress, amount);
        IAaveLendingPool(lendingPoolAddress).deposit(tokenAddress, amount, 0);

        return true;
    }

    function withdraw(uint256 amount) internal returns (bool) {
        IAToken(aTokenAddress).redeem(amount);

        return true;
    }

    function getPoolBalance() public view returns (uint256) {
        (uint256 balance, , , , , , , , , ) = IAaveLendingPool(
            lendingPoolAddress
        )
            .getUserReserveData(tokenAddress, address(this));

        return balance;
    }
}

interface IAaveLendingPool {
    function deposit(
        address _reserve,
        uint256 _amount,
        uint16 _referralCode
    ) external;

    function getUserReserveData(address _reserve, address _user)
        external
        view
        returns (
            uint256 currentATokenBalance,
            uint256 currentBorrowBalance,
            uint256 principalBorrowBalance,
            uint256 borrowRateMode,
            uint256 borrowRate,
            uint256 liquidityRate,
            uint256 originationFee,
            uint256 variableBorrowIndex,
            uint256 lastUpdateTimestamp,
            bool usageAsCollateralEnabled
        );
}

interface IAaveLendingPoolCore {
    function getReserveCurrentLiquidityRate(address _reserve)
        external
        view
        returns (uint256);

    function getReserveCurrentStableBorrowRate(address _reserve)
        external
        view
        returns (uint256);
}

interface IAToken {
    function redeem(uint256 _amount) external;
}
