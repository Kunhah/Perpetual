// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { ERC4626 } from "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import { IERC20 } from "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "../node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { Ownable } from "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import { ITrader } from "./ITrader.sol";

//I need to erase the abstract but I don't know how to fix the error
contract TimeLockedVault is ERC4626, Ownable {
    using SafeERC20 for IERC20;

    //IERC20 test = IERC20(0x0000000000000000000000000000000000000000);
    
    uint32 constant MINIMUM_LOCKED_TIME = 10 days;
    uint64 constant PERCENTAGE_PRECISION = 1000;
    uint64 constant PERCENTAGE_PRECISION_TIMES_HUNDRED = 100000;
    uint64 constant TIME_TO_ONE_PERCENT = 30 days;
    uint64 constant MINIMUM_PERCENTAGE = 80000;
    uint64 constant MAXIMUM_PERCENTAGE = 95000;
    address constant FEE_RECEIVER = 0x9034249726000ac1DF25636bE95c6FfFB8228712;

    address trader;

    address immutable i_vaultToken;

    error TimeLockedVault_TimeIsLessThanMinimun(uint64 lockedTime);

    error TimeLockedVault_TimeDidNotExpired(uint64 lockedTime);

    error TimeLockedVault_RewardPercentageOutOfBounds(uint64 rewardRatio);

    error TimeLockedVault_MintIsNotAllowed();

    error TimeLockedVault_RedeemIsNotAllowed();

    error TimeLockedVault_NotEnoughAssets(uint256 totalAssets);

    error TimedLockedVault_SenderIsNotTheTrader(address sender);

    mapping(address => uint64) s_lockedUntilThisTimestamp;
    mapping(address => uint64) s_startDepositTimestamp;
    mapping(address => uint256) s_totalDeposited;

    /* constructor(address _vaultToken) ERC4626(IERC20(_vaultToken)) Ownable(msg.sender) {
            i_vaultToken = _vaultToken;
    } */

    constructor(address _vaultToken, address _owner) ERC4626(IERC20(_vaultToken)) Ownable(_owner) {
        i_vaultToken = _vaultToken;
    }

    function setTrader(address _trader) external {
    trader = _trader;
    }

    function transferTokenstoTrader(uint256 amount) external {
        if(msg.sender != trader && msg.sender != owner())
            revert TimedLockedVault_SenderIsNotTheTrader(msg.sender);
        IERC20(i_vaultToken).safeTransfer(trader, amount);
    }

     /**
      * 
      * @param assets amount of the ERC20 that the vault keeps
      * @param receiver address that receives the shares
      * @param lockedTime the amount of time that the user will have to wait until he is able to remove his tokens
      */   
     function depositDefiningTimeLock(uint256 assets, address receiver, uint64 lockedTime) external returns (uint256) {
        if (lockedTime < MINIMUM_LOCKED_TIME)
                revert TimeLockedVault_TimeIsLessThanMinimun(lockedTime);
        
        //uint64 _lockedUntilThisTimestamp = lockedUntilThisTimestamp[msg.sender];

        if(s_lockedUntilThisTimestamp[msg.sender] >= block.timestamp) 
        s_lockedUntilThisTimestamp[msg.sender] += uint64(lockedTime - MINIMUM_LOCKED_TIME);
        else
        s_lockedUntilThisTimestamp[msg.sender] = uint64(block.timestamp + lockedTime - MINIMUM_LOCKED_TIME);
        return deposit(assets, _msgSender());
    } /*

    function withdrawWithTimeLock(uint256 assets, address receiver, address owner) public returns (uint256) {
        uint256 maxAssets = maxWithdraw(owner);
        
        withdraw();
    }

    function redeemWithTimeLock(uint256 shares, address receiver, address owner) public returns (uint256) {
        uint256 maxShares = maxRedeem(owner);
        if (shares > maxShares) {
            revert ERC4626ExceededMaxRedeem(owner, shares, maxShares);
        }

        uint256 assets = previewRedeem(shares);
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        redeem();
    } */

    /**
     * Always deposits with the minimun timelock
     * @param assets amount of the ERC20 that the vault keeps
     * @param receiver address that receives the shares
     */
    function deposit(uint256 assets, address receiver) public override returns (uint256) {
        if(s_lockedUntilThisTimestamp[msg.sender] >= block.timestamp) 
        s_lockedUntilThisTimestamp[msg.sender] += MINIMUM_LOCKED_TIME;
        else
        s_lockedUntilThisTimestamp[msg.sender] = uint64(block.timestamp + MINIMUM_LOCKED_TIME);

        if(s_startDepositTimestamp[msg.sender] == 0)
            s_startDepositTimestamp[msg.sender] = uint64(block.timestamp);
        
        uint256 maxAssets = maxDeposit(_msgSender());
        if (assets > maxAssets) {
            revert ERC4626ExceededMaxDeposit(receiver, assets, maxAssets);
        }

        uint256 shares = previewDeposit(assets);
        _deposit(_msgSender(), _msgSender(), assets, shares);

        s_totalDeposited[msg.sender] += assets;

        return shares;
    }

    /**
     * The ERC4626 function
     * @param shares the shares that relate to the vault's assets
     * @param receiver address that receive the shares
     */
    function mint(uint256 shares, address receiver) public override returns (uint256) {
        revert TimeLockedVault_MintIsNotAllowed();
    }

    /**
     * The ERC4626 function but checking if the time has expired
     * @param assets amount of the ERC20 that the vault keeps
     * @param receiver address that receive the asstes
     * @param owner owner
     */
    function withdraw(uint256 assets, address receiver, address owner) public override returns (uint256) {
        if(s_lockedUntilThisTimestamp[owner] > block.timestamp)
            revert TimeLockedVault_TimeDidNotExpired(uint64(block.timestamp));
        uint256 maxAssets = maxWithdraw(owner);
        uint256 totalDeposited = s_totalDeposited[msg.sender];
        if(totalDeposited < maxAssets)
            revert TimeLockedVault_NotEnoughAssets(totalAssets());
        /* if (assets > maxAssets) {
            revert ERC4626ExceededMaxWithdraw(owner, assets, maxAssets);
        } */
        uint64 rewardPercentage = calculateRewardPercentage();

        uint256 fee = (((PERCENTAGE_PRECISION_TIMES_HUNDRED - rewardPercentage)*(totalDeposited - maxAssets))/PERCENTAGE_PRECISION_TIMES_HUNDRED);

        // ((rewardPercentage*assets)/100000)   that goes to the liquidity providers
        // (((100000 - rewardPercentage)*assets)/100000)   that goes to the protocol to pay other types of fees
        uint256 shares = previewWithdraw(maxAssets);

        _withdraw(_msgSender(), receiver, owner, maxAssets - fee, shares);

        _withdraw(_msgSender(), receiver, FEE_RECEIVER, fee, shares);

        //@audit there is a problem if caller is not the owner, how is the timelock going to work?

        s_startDepositTimestamp[msg.sender] = 0;

        return shares;
    }

    /* function withdrawAll(address receiver, address owner) public returns (uint256) {

        return withdraw(maxWithdraw(owner), receiver, owner);
    } */

    /**
     * The ERC4626 function but checking if the time has expired
     * @param shares the shares that relate to the vault's assets
     * @param receiver address that receive the asstes
     * @param owner owner
     */
    function redeem(uint256 shares, address receiver, address owner) public override returns (uint256) {
        revert TimeLockedVault_RedeemIsNotAllowed();
    }

    function calculateRewardPercentage() public view returns(uint64) {
        uint64 rewardPercentage = MINIMUM_PERCENTAGE + (((s_lockedUntilThisTimestamp[msg.sender] - s_startDepositTimestamp[msg.sender]) * PERCENTAGE_PRECISION)/TIME_TO_ONE_PERCENT);

        if(rewardPercentage > MAXIMUM_PERCENTAGE) 
            rewardPercentage = MAXIMUM_PERCENTAGE;
        
        //if(rewardPercentage > 95000 || rewardPercentage < 80000)
            //revert TimeLockedVault_RewardPercentageOutOfBounds(rewardPercentage);
        return rewardPercentage;
    }
}