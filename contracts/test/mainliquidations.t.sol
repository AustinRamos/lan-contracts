// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//import "forge-std/Test.sol";
import "../src/mainliquidations.sol";
import "../src/USDC.sol";
import "../src/SimpleNft.sol";
import {console} from "forge-std/console.sol";

import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "./utils/Utils.sol";

contract CounterTest is Test {
LAN public lan;
USDC public usdc;
SimpleNft public Nft;
Utils internal utils;
address payable[] internal users;

address internal alice;
address internal bob;

    function setUp() public {
    lan = new LAN();
    usdc = new USDC(1000000);
    Nft = new SimpleNft();
       utils = new Utils();
        users = utils.createUsers(5);

        alice = users[0];
        vm.label(alice, "Alice");
        bob = users[1];
        vm.label(bob, "Bob");
Nft.mintForAddress(1, address(alice), 0);
vm.prank(address(alice));
   Nft.approve(address(lan),0);

    vm.startPrank(address(alice));
         Nft.approve(address(lan),0);
         //maybe alice is launching auction and bob bidss on it... 
           // vm.prank(address(alice));
           //console.log("TEST",block.timestamp);
         lan.launch(
             address(0),
             address(usdc),
             address(0),
             address(Nft),
             0,
             block.timestamp,
             block.timestamp+(60 * 60 * 24 * 365),
             true,
             false

         );
 vm.stopPrank();

    }

     function testLaunch() public {
         console.log(address(lan));
      
        assertEq(lan.count(),1);
        address owner = Nft.ownerOf(0);
        assertEq(owner,address(lan));
    }

//and on test bid have a third personcharlie bid on it and get t frombob, 
//make sure bob gets money back
//dont let ??


    function testBid() public{

console.log("TEST ", usdc.balanceOf(address(this)));
//send bob usdc

    usdc.transfer(address(bob),10000);

    vm.startPrank(address(bob));
     uint balancebefore = usdc.balanceOf(address(alice));
    
uint amount = 10000;
    //bob approves usdc spend of lan contract
    usdc.approve(address(lan),amount);
   // console.log("approval " , usdc.)
    //bob bids on alice nft loan
    lan.bid(0,amount,10,0);

        assertEq(balancebefore+amount,usdc.balanceOf(address(alice)));
//assert money goes to alice?
    }
//will accept make bid with bob, wait 5days and liquidate loan/repay+interest? and verify
 function testInterest() public {

usdc.transfer(address(bob),10000);

    vm.startPrank(address(bob));
  
    uint amount= 1000;
      usdc.approve(address(lan),amount);
    lan.bid(
        0,amount,100,0
    );

    ( , , , , , uint endTime , ) = lan.getLoan(0);
    console.log(endTime);
    vm.warp(endTime);



    //bob bids, so we liquidate loan now 
    console.log("Before: ", usdc.balanceOf(address(bob)));
    lan.liquidate(0);
        console.log("After: ", usdc.balanceOf(address(bob)));




 }

// function testRepay() public{

//     //assert Nft is back in wallet. assert money?
// }

function testInterestAccrual() public
   {
       //launch, bid, and push block forward
         //     // counter.setNumber(x);
    //     // assertEq(counter.number(), x);
    // }
}
}
