// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {PengwinToken} from "../src/PengwinToken.sol";

contract DeployToken is Script {
    uint256 public constant INITIAL_SUPPLY = 10000 ether;
    function run() external returns (PengwinToken) {
        vm.startBroadcast();
        PengwinToken pt = new PengwinToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return pt;
    }
        
}
    