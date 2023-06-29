
# nUSD Stablecoin
This is the smart contract that enables users to deposit ETH and receive 50% of its value in nUSD 

## NOTE
- As we cannot store the float values in solidity so the fetching of real price using oracke chainlink has been rounded off to ethe nearest value



## Features

- used oracle chainlink to fetch real eth price in USD
- used aggregateV3Interface  to fetch the real ether price in used
- with help of deposit function the user will be able to mint hte tokens according to the real eth price in usd 
- with help of redeem fucntion the user will burn the tokens and convert there nUSD to eth 
- total supply will change accordingly for the particular user
- direct sending of ether to contract is prevented using fallback and recieve function
- deposits array is amde to keep the track of the addresses who have made a deposit
- usdgot mapping is made to keep the track of the amount of usd particular address got 
- events are emitted accordingly
- made all the variables private/internal so that other contracts cannot change the values, so to fetch those variables made external  functions respectively 
- made fucntions external to save gas





## Tech Stack 

 - Solidity language is used 
 - address of sepolia testnet is used in aggregateV3Interface
 
## 🔗 Links

[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/shubham-garg-6232181b8/)


