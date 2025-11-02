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
        savingspool = new savingsPool(address(token));
        token.transfer(user, 500);
    }

    function testcreatePlan() public {
       vm.prank(user);
       savingspool.createPlan(10000000);
       assertEq(savingspool.userPlanCount(user), 1);
       (, , , bool withdrawn) = savingspool.userPlans(user, 1);
       assertFalse(withdrawn, 'no withdrawn yet');
       (, , uint256 balance, ) = savingspool.userPlans(user, 1);
       assertEq(balance, 0);
    }

    function testdeposit() public {
       
    }

}