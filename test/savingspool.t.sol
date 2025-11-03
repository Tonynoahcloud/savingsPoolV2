// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {savingsPool} from "../src/savingsPool.sol";
import {anthonyToken} from "../src/anthonyToken.sol";


contract savingsPoolTest is Test{
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
       (, , , bool withdrawn) = savingspool.userPlans(user, 1);
       assertFalse(withdrawn, 'no withdrawn yet');
       (, , uint256 balance, ) = savingspool.userPlans(user, 1);
       assertEq(balance, 0);
    }

    function test_Revert_createPlan_whengoalamountiszero() public {
        vm.prank(user);
        vm.expectRevert();
        savingspool.createPlan(0);
        
    }

    function test_Revert_createPlan_checkwithdrawiszero() public {
        vm.prank(user);
        savingspool.createPlan(1000);
        (, , , bool withdrawn) = savingspool.userPlans(user, 1);
        assertFalse(withdrawn, 'no withdrawal yet');
    }
   
    function test_Revert_createPlan_balanceiszero() public {
        vm.prank(user);
        (, , uint256 balance, ) = savingspool.userPlans(user, 1);
        assertEq(balance, 0);
    }

    function test_Emit_createPlan() public {
        vm.prank(user);
        vm.expectEmit(true, true, false, true);
        emit savingsPool.planCreated(user, 1, 200);
        savingspool.createPlan(200);
    }

}