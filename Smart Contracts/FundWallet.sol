pragma solidity 0.4.18;

contract FundWallet {

    //storage
    address public admin;
    uint public adminStake;
    uint public balance;
    bool public adminStaked;
    mapping (address => bool) public isContributor;
    mapping (address => uint) public stake;
    address[] public contributors;
    //experimental time periods
    uint start;
    uint raiseP;
    uint opperateP;
    uint liquidP;

    //modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    modifier onlyContributor() {
        require(isContributor[msg.sender]);
        _;
    }

    modifier adminHasStaked() {
        require(adminStaked == true);
        _;
    }

    modifier adminHasNotStaked() {
        require(adminStaked == false);
        _;
    }

    //need to test time based modifiers -- currently just conceptual
    modifier inRaiseP() {
        require(now < (start + raiseP));
        _;
    }

    modifier inOpperateP() {
        require(now < (start + raiseP + opperateP) && now > (start + raiseP));
        _;
    }

    modifier inLiquidP() {
        require(now < (start + raiseP + opperateP + liquidP) && now > (start + raiseP + opperateP));
        _;
    }

    modifier inClaimP() {
        require(now > (start + raiseP + opperateP + liquidP));
        _;
    }

    //events
    event ContributorAdded(address _contributor);
    event ContributorRemoval(address _contributor);
    event ContributorDeposit(address sender, uint value);
    event AdminDeposit(address sender, uint value);

    function FundWallet(address _admin, uint _adminStake, uint _raiseP, uint _opperateP, uint _liquidP) public {
        require(_admin != address(0));
        require(_adminStake > 0);
        admin = _admin;
        adminStake = _adminStake;
        start = now;
        raiseP = _raiseP * (24 hours);
        opperateP = _opperateP * (24 hours);
        liquidP = _liquidP * (24 hours);
    }

    function() public payable {
        revert();
    }

    function addContributor(address _contributor) public onlyAdmin {
        require(!isContributor[ _contributor]); //only new contributor
        require(_contributor != admin);
        isContributor[ _contributor] = true;
        contributors.push( _contributor);
        ContributorAdded( _contributor);
    }

    function removeContributor(address _contributor) public onlyAdmin {
        require(isContributor[_contributor]);
        isContributor[_contributor] = false;
        for (uint i=0; i < contributors.length - 1; i++)
            if (contributors[i] == _contributor) {
                contributors[i] = contributors[contributors.length - 1];
                break;
            }
        contributors.length -= 1;
        ContributorRemoval(_contributor);
    }
    //return contributions on removal if contributions have been made

    function getContributors() public constant returns (address[]){
        return contributors;
    }

    function contributorDeposit() public onlyContributor adminHasStaked payable {
        if (adminStake >= msg.value && msg.value > 0 && stake[msg.sender] < adminStake) {
            balance += msg.value;
            stake[msg.sender] += msg.value;
            ContributorDeposit(msg.sender, msg.value);
        }
        else {
            revert();
        }
    }

    function adminDeposit() public onlyAdmin adminHasNotStaked payable {
        if (msg.value == adminStake) {
            balance += msg.value;
            stake[msg.sender] += msg.value;
            adminStaked = true;
            AdminDeposit(msg.sender, msg.value);
        }
        else {
            revert();
        }
    }
    //make a single deposit function
}
