pragma solidity 0.4.19;

contract EthTransferFrom {
    
    mapping(address => bool) public approved;
    
    modifier onlyApproved() {
        require(approved[msg.sender]);
        _;
    }
    
    
    function EthTransferFrom(address _approve) public {
        approved[_approve] = true;
    }
    
    function transferFrom(address _to, uint _amount) onlyApproved public {
        require(address(this).balance >= _amount);
        _to.transfer(_amount);
    }
    
    function() public payable {
        
    }
}
