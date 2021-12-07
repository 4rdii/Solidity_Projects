// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;


import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
//interffaces compile to ABIs which tells the contract which functions 
// oon another contract can be called 

//import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol"; 
// for solidity lower than 0.8.0 is needed to check for overflow of uint and int variables 

contract fundme {
    using SafeMathChainlink for uint256; // attaching safmath to uint256
    mapping (address => uint256) public AddressToAmountFounded; 
    address public owner;
    address[] public funders;
    constructor() public {
        owner = msg.sender;
    }
    
    function fund() public payable{
        uint256 minimumUSD = 50*10**18; 
        require(getConversionRate(msg.value) >= minimumUSD, "You need to send at least 50 usd worth of ETH");
        AddressToAmountFounded[msg.sender] += msg.value;
        funders.push(msg.sender); 
        // what is eth to usdt conversiont rate 
        // the conversion rate comes from oracles - api calls are always from oracles - blockchains cant call apis 
        // oracles cant be centeralized and data should come from many sources 
    }
    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }
    function getPrice() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 10**10); 
    }

    function getConversionRate ( uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 usdtAmount = ethAmount * ethPrice / (10**18) ; 
        return usdtAmount;
        //uint256: 4281854477590 * 10**-18
    }

    modifier onlyOwner{
        require (msg.sender == owner, "not owner");
        _;
    }

    function withdraw() payable onlyOwner public {
        //require (msg.sender == owner, ' Not Owner Bro!');
        msg.sender.transfer(address(this).balance); // sends all funded eth form contract address to msg sender address
        for( uint256 index = 0; index < funders.length ; index++ ){
            address funder = funders[ index];
            AddressToAmountFounded[funder] = 0;
        }
        funders = new address[](0);
    }
}