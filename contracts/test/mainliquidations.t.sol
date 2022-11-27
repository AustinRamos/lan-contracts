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
    }

     function testLaunch() public {
         console.log(address(lan));
        //vm.prank(address(alice));
        vm.startPrank(address(alice));
         Nft.approve(address(lan),0);
         //maybe alice is launching auction and bob bidss on it... 
           // vm.prank(address(alice));
         lan.launch(
             address(0),
             address(usdc),
             address(0),
             address(Nft),
             0,//NEED TO MIND IT AND APPROVE ITS TRANSFER HERE. ,
             block.timestamp,
             block.timestamp+500,
             false,
             false

         );
        assertEq(lan.count(),1);
        address owner = Nft.ownerOf(0);
        assertEq(owner,address(lan));
    }

    function testBid() public{

//assert money goes to alice?
    }

function testRepay() public{

    //assert Nft is back in wallet. assert money?
}

function testInterestAccrual() public
   {
       //launch, bid, and push block forward
         //     // counter.setNumber(x);
    //     // assertEq(counter.number(), x);
    // }
}
}
