// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);
//   function description() external view returns (string memory);
//   function version() external view returns (uint256);
//   function getRoundData(uint80 _roundId) external view returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );
//   function latestRoundData() external view returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );
// }

contract FundMe {

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;


    constructor() public {
        // when contract gets initialized, the sender is set as the owner.
        owner = msg.sender;
    }

    function fund() public payable {

        // e.g. $60
        uint256 minimumUSD = 50 * 10 ** 18;
        // if (msg.value < minimumUSD) {
        //     // revert
        // }
        require(getConversionRate(msg.value) >= minimumUSD, "Amount not sufficient (min 50$)!");

        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);

        // What the ETH -> USD conversion rate is

    }

    function getVersion() public view returns (uint256) {
        // We have a contract located at this address
        // That implements the methods from this `AggregatorV3Interface`
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);

        // If that is true, we can call its version like so
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        // (
        //     uint80 roundId,
        //     int256 answer,
        //     uint256 startedAt,
        //     uint256 updatedAt,
        //     uint80 answeredInRound
        // ) = priceFeed.latestRoundData();
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {

       uint256 ethPrice = getPrice();
       uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;

       return ethAmountInUsd;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
        // before you run the actual code (_) run the first require statement.
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex = 0; funderIndex < funders.length;  funderIndex ++) {
            address funderAddress = funders[funderIndex];
            addressToAmountFunded[funderAddress] = 0;
        }
        // set funders to a new blanc address array
        funders = new address[](0);
    }
}
