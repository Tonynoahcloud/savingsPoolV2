// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {savingsPool} from "../src/savingsPool.sol";
import {anthonyToken} from "../src/anthonyToken.sol";

contract savingsPoolTest is Test {
    savingsPool public savingspool;
    anthonyToken public token;
    address user = address(1);

    function setUp() public {
        savingspool = new savingsPool(address(this));
        token = new anthonyToken();
    }

    function testcreatePlan_success() public {
        vm.prank(user);
        savingspool.createPlan(1000);
        assertEq(savingspool.userPlanCount(user), 1);
        (,,, bool withdrawn) = savingspool.userPlans(user, 1);
        assertFalse(withdrawn, "no withdrawn yet");
        (,, uint256 balance,) = savingspool.userPlans(user, 1);
        assertEq(balance, 0);
    }

    function test_Revert_createPlan_whengoalamountiszero() public {
        vm.prank(user);
        vm.expectRevert();
        savingspool.createPlan(0);
    }

    function test_Emit_createPlan() public {
        vm.prank(user);
        vm.expectEmit(true, true, true, true);
        emit savingsPool.planCreated(user, 1, 200);
        savingspool.createPlan(200);
    }

    function test_Revert_deposit_noId() public {
        vm.startPrank(user);
        
        savingspool.createPlan(1000);
        vm.expectRevert("Invalid Plan ID");
        savingspool.deposit(0, 500);
        vm.stopPrank();
        
    }

    function test_Revert_deposit_amountlessthanzero() public {
        vm.startPrank(user);
        savingspool.createPlan(500);
        vm.expectRevert("Amount must be greater than zero");
        savingspool.deposit(1, 0);
        vm.stopPrank();
    }

    function test_Revert_deposit_noplanidforuser() public {
        vm.startPrank(user);
        savingspool.createPlan(300);
        vm.expectRevert("Plan ID does not exist for user");
        savingspool.deposit(2, 200);
    }

    function test_Emit_deposit() public {
        vm.startPrank(user);
        savingspool.createPlan(3000);
        token.approve(address(savingspool), 5000);
        vm.expectEmit(true, true, false, true, address(savingspool));
        emit savingsPool.DepositMade(user, 1, 3000);
        savingspool.deposit(1, 3000);
        vm.stopPrank();
      
    }
   
}
