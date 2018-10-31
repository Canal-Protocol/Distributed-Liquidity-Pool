pragma solidity 0.4.18;

// EXPERIMENTAL ONLY - Funds will be FROZEN

//functions to allow for kyber reserve token wallet to be a smart contract.


interface ERC20 {
    function totalSupply() public view returns (uint supply);
    function balanceOf(address _owner) public view returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint remaining);
    function decimals() public view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

interface TradeWalletInterface {
    function pullToken(ERC20 token, uint amount, address sendTo) external;
    function pullEther(uint amount, address sendTo) external;
}

contract TestTradeW {

    TradeWalletInterface public TradeWallet;

    function TestTradeW (TradeWalletInterface _TradeWallet) public {
        TradeWallet = _TradeWallet;
    }

    function tokenPuller (ERC20 destToken, address destAddress, uint destAmount) public {
        TradeWallet.pullToken(destToken, destAmount, destAddress);

    }

    function etherPuller (address destAddress, uint destAmount) public {
        TradeWallet.pullEther(destAmount, destAddress);
    }

}
