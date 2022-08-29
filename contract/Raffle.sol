// SPDX-License-Identifier: MIT

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

error Raffle__NotEnoughETHEntered();


contract Raffle is VRFConsumerBaseV2 {
    uint256 private immutable i_entranceFee;
    address[] payable[] private s_players;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gaslane;

    event RaffleEnter(address indexed player);

    constructor(address vrfCoordinatorV2, uint256 entranceFee, bytes32 gaslane) VRFConsumerBaseV2(vrfCoordinatorV2){
        i_entranceFee = entranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gaslane = gaslane;
    }

    function enterRaffle() public payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughETHEntered();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEnter(msg.sender);
    }

    function requestRandomWinner() external {
        i_vrfCoordinator.requestRandomWords(
            i_gaslane, //gaslane

        )
    }

    function fulfillRandomWords(uin256 requestId, uint256[] memory randomWords) internal override(){

    }

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getPlayer() public view returns(address){
        return s_players;
    }
}
