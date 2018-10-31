pragma solidity 0.4.18;

// EXPERIMENTAL ONLY

// test for integration with Kyber Reserve - replicating the send dest tokens component. 

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
    
    /// @dev Constructor sets the TradeWallet address
    /// @ param _TradeWallet is the funding source wallet (TradeWallet will be integrate with FundWallet in the future).
    function TestTradeW (TradeWalletInterface _TradeWallet) public {
        TradeWallet = _TradeWallet;
    }

    /// @dev replicates the send dest tokens where the token address is an ERC20
    function tokenPuller (ERC20 destToken, address destAddress, uint destAmount) public {
        TradeWallet.pullToken(destToken, destAmount, destAddress);

    }

    /// @dev replicates the send dest tokens where the token address is Ether
    function etherPuller (address destAddress, uint destAmount) public {
        TradeWallet.pullEther(destAmount, destAddress);
    }

}
