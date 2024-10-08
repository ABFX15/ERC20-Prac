// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployToken} from "../script/DeployToken.s.sol";
import {PengwinToken} from "../src/PengwinToken.sol";   

interface MintableToken {
    function mint(address, uint256) external;
}

contract PengwinTestToken is Test {
    PengwinToken public pengwinToken;
    DeployToken public deployer;

    address Adam = makeAddr("Adam");
    address Char = makeAddr("Char");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployToken();
        pengwinToken = deployer.run();

        vm.prank(msg.sender);
        pengwinToken.transfer(Adam, STARTING_BALANCE);
    }

    function testAdamBalance() public view {
        assertEq(STARTING_BALANCE, pengwinToken.balanceOf(Adam));
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;
        vm.prank(Adam);
        pengwinToken.approve(Char, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(Char);
        pengwinToken.transferFrom(Adam, Char, transferAmount);

        assertEq(pengwinToken.balanceOf(Char), transferAmount);
        assertEq(pengwinToken.balanceOf(Adam), STARTING_BALANCE - transferAmount);
    }

    function testTransfer() public {
        uint256 transferedAmount = 250;
        vm.prank(Adam);
        pengwinToken.transfer(Char, transferedAmount);
        assertEq(pengwinToken.balanceOf(Char), transferedAmount);
    }

    function testInitialSupply() public view {
        assertEq(pengwinToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCanMint() public {
        vm.expectRevert();
        MintableToken(address(pengwinToken)).mint(address(this), 1);
    }
}
