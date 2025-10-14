// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract savingsPool {
    IERC20 public token;

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    struct SavingsPlan {
        uint256 iD;
        uint256 goalAmount;
        uint256 balance;
        bool withdrawn;
    }

    mapping(address => mapping(uint256 => SavingsPlan)) public userPlans;
    mapping(address => uint256) public userPlanCount;
    mapping(uint256 => SavingsPlan) mySavingplans;

    event planCreated(address indexed user, uint256 indexed planId, uint256 goalAmount);
    event DepositMade(address indexed user, uint256 _planId, uint256 _amount);

    function createPlan(uint256 _goalAmount) external {
        require(_goalAmount > 0, "E");
        userPlanCount[msg.sender]++;
        uint256 userSpecificId = userPlanCount[msg.sender];

        SavingsPlan storage s = userPlans[msg.sender][userSpecificId];

        s.iD = userSpecificId;
        s.goalAmount = _goalAmount;
        s.balance = 0;
        s.withdrawn = false;
        emit planCreated(msg.sender, userSpecificId, _goalAmount);
    }

    function deposit(uint256 _planId, uint256 _amount) external {
        require(_planId > 0, "Invalid Plan ID");
        require(_amount > 0, "Amount must be greater than zero");

        require(_planId <= userPlanCount[msg.sender], "Plan ID does not exist for user");

        require(token.allowance(msg.sender, address(this)) >= _amount, "Insufficient allowance for transfer");
        require(token.transferFrom(msg.sender, address(this), _amount), "failed");

        SavingsPlan storage plan = userPlans[msg.sender][_planId];

        plan.balance += _amount;

        emit DepositMade(msg.sender, _planId, _amount);
    }
}
