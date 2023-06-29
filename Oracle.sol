// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// following the chainlink standards and importing the interface to use the method provided by chainlink to fetch real price of eth
import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// deploying my nUSD token
contract MyToken is ERC20 {
    address public owner;

    constructor() ERC20("MyToken", "nUSD") {
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(address to, uint256 amount) public {
        _burn(to, amount);
    }
}

contract Oracle {
    // to fetch real eth price using aggregateV3interface
    AggregatorV3Interface internal immutable priceFeed;
    // to keep the track of addresses who have made deposit
    address[] internal deposits;
    // to keep the track of nUSD got made mapping
    mapping(address => uint256) internal usdcGot;
    MyToken internal immutable token;
    //event to track the amount of nUSD got in return to ETH
    event depositedETHAndUSDGot(address a, uint256 amountOfUSDGot);
    // event to track the amount in WEI got for nUSD
    event redeemETH(address a, uint256 amountOfWEIGot);

    constructor(address _token) {
        //calling the constructor of Aggregator with sepolia testnet address of USD
        priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        token = MyToken(_token);
    }

    // internal function to fetch real price of ETH in usd
    function getRealPrice() internal view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    // function to deposit ETH and get nUSD (token)
    function depositEth() public payable {
        require(msg.value > 0, "You need to send some ethers to get tokens");
        int256 realPrice = getRealPrice(); // fetching the real price
        uint256 adjusted = uint256(realPrice) * 10**10;
        uint256 amountToTransfer = (adjusted * msg.value * 50) / 10**38; // calculating the amount that user should get i.e 50%
        deposits.push(msg.sender); // storing the address in deposit array
        usdcGot[msg.sender] = amountToTransfer;
        token.mint(msg.sender, amountToTransfer); // minting the tokens
        emit depositedETHAndUSDGot(msg.sender, amountToTransfer);
    }

    // function to know the the amount of nUSD particular address got
    function getUsdcAmount(address a) external view returns (uint256) {
        return usdcGot[a];
    }

    function getDeposite(uint256 index) external view returns (address) {
        return deposits[index];
    }

    // fucntion to reddeem the ETH for nUSD
    function redeem(uint256 amount) external {
        require(
            token.balanceOf(msg.sender) >= amount,
            "You do not have enough tokens"
        );
        token.burn(msg.sender, amount); // burning the tokens
        int256 realPrice = getRealPrice();
        uint256 adjustedPrice = uint256(realPrice) * 10**10;
        uint256 amountinWei = (amount * 2 * (10**18) * 10**18) / adjustedPrice; // calculating the amount in WEI the person shluld get for nUSD
        payable(msg.sender).transfer(amountinWei);
        emit redeemETH(msg.sender, amountinWei);
    }

    //function to prevent contract from receiving ethers directly
    fallback() external payable {
        depositEth();
    }

    //function to prevent contract from receiving ethers directly
    receive() external payable {
        depositEth();
    }
}
