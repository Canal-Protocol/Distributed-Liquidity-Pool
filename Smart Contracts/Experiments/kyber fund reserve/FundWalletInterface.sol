pragma solidity 0.4.18;

interface FundWalletInterface {
    function() public payable;
    function pullToken(ERC20 token, uint amount, address sendTo) external;
    function pullEther(uint amount, address sendTo) external;
    function checkBalance(ERC20 token) public view returns (uint);
}
