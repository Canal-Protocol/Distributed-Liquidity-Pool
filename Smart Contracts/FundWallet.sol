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
    //admin operational withdrawal
    uint public lastDay;
    uint public withdrawnToday;

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
        assert(adminStaked == true);
        _;
    }

    modifier adminHasNotStaked() {
        assert(adminStaked == false);
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
    event ContributorDepositReturn(address _contributor, uint value);
    event AdminDeposit(address sender, uint value);
    event AdminDepositReturned(address sender, uint value);

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

    function addContributor(address _contributor) public onlyAdmin inRaiseP {
        require(!isContributor[ _contributor]); //only new contributor
        require(_contributor != admin);
        isContributor[ _contributor] = true;
        contributors.push( _contributor);
        ContributorAdded( _contributor);
    }

    function removeContributor(address _contributor) public onlyAdmin inRaiseP {
        require(isContributor[_contributor]);
        isContributor[_contributor] = false;
        for (uint i=0; i < contributors.length - 1; i++)
            if (contributors[i] == _contributor) {
                contributors[i] = contributors[contributors.length - 1];
                break;
            }
        contributors.length -= 1;
        ContributorRemoval(_contributor);

        if (stake[_contributor] > 0) {
            _contributor.transfer(stake[_contributor]);
            balance -= stake[_contributor];
            delete stake[_contributor];
            ContributorDepositReturn(_contributor, stake[_contributor]);
        }
    }
    //return contributions on removal if contributions have been made

    function getContributors() public constant returns (address[]){
        return contributors;
    }

    function contributorDeposit() public onlyContributor adminHasStaked inRaiseP payable {
        if (adminStake >= msg.value && msg.value > 0 && stake[msg.sender] < adminStake) {
            balance += msg.value;
            stake[msg.sender] += msg.value;
            ContributorDeposit(msg.sender, msg.value);
        }
        else {
            revert();
        }
    }

    function contributorRefund() public onlyContributor inRaiseP {
        isContributor[msg.sender] = false;
        for (uint i=0; i < contributors.length - 1; i++)
            if (contributors[i] == msg.sender) {
                contributors[i] = contributors[contributors.length - 1];
                break;
            }
        contributors.length -= 1;
        ContributorRemoval(msg.sender);

        if (stake[msg.sender] > 0) {
            msg.sender.transfer(stake[msg.sender]);
            balance -= stake[msg.sender];
            delete stake[msg.sender];
            ContributorDepositReturn(msg.sender, stake[msg.sender]);
        }
    }

    function adminDeposit() public onlyAdmin adminHasNotStaked inRaiseP payable {
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

    function adminRefund() public onlyAdmin adminHasStaked inRaiseP {
        require(balance == adminStake);
        admin.transfer(adminStake);
        adminStaked = false;
        balance -= adminStake;
        AdminDepositReturned(msg.sender, adminStake);
    }

    //still need to test functions below this:
    function opsWithdraw(uint _amount) public onlyAdmin inOpperateP {
        assert(isUnderLimit(_amount));
        admin.transfer(_amount);
        withdrawnToday += _amount;
    }

    function isUnderLimit(uint amount) internal returns (bool) {
        if (now > lastDay + 24 hours) {
            lastDay = now;
            withdrawnToday = 0;
        }
        if (withdrawnToday + amount > adminStake || withdrawnToday + amount < withdrawnToday)
            return false;
        return true;
    }

    function calcMaxOpsWithdraw() public constant returns (uint)  {
        if (now > lastDay + 24 hours)
            return adminStake;
        if (adminStake < withdrawnToday)
            return 0;
        return adminStake - withdrawnToday;
    }
}
