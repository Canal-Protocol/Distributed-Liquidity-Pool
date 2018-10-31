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

contract TradeWallet {

    address reserve;
    address admin;

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    function TradeWallet(address _admin, address _reserve) public {
        admin = _admin;
        reserve = _reserve;
    }

    function() public payable {
    }

    function setReserve (address _newReserve) onlyAdmin public {
        reserve = _newReserve;
    }

    event TokenPulled(ERC20 token, uint amount, address sendTo);

    /**
     * @dev send erc20token to the destination address
     * @param token ERC20 The address of the token contract
     */
    function pullToken(ERC20 token, uint amount, address sendTo) external {
        require(msg.sender == reserve);
        require(token.transfer(sendTo, amount));
        TokenPulled(token, amount, sendTo);
    }

    event EtherPulled(uint amount, address sendTo);

    /**
     * @dev Send ether to the destination address
     */
    function pullEther(uint amount, address sendTo) external {
        require(msg.sender == reserve);
        sendTo.transfer(amount);
        EtherPulled(amount, sendTo);
    }
}
