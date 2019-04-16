pragma solidity 0.4.18;

contract FwPermissions {

  address public admin;
  address public backupAdmin;
  //Kyber Reserve contract address
  address public reserve;
  bool public timePeriodsSet;
  bool public adminStaked;
  bool public endBalanceLogged;
  mapping (address => bool) public isContributor;
  mapping (address => bool) public hasClaimed;
  address[] public contributors;
  //experimental time periods
  uint public start;
  uint public adminP;
  uint public raiseP;
  uint public opperateP;
  uint public liquidP;

  function FwPermissions() public {
        admin = msg.sender;
  }

  //modifiers
  modifier onlyAdmin() {
      require(msg.sender == admin);
      _;
  }

  modifier onlyBackupAdmin() {
      require(msg.sender == backupAdmin);
      _;
  }

  modifier timePeriodsNotSet() {
      require(timePeriodsSet == false);
      _;
  }

  modifier timePeriodsAreSet() {
      require(timePeriodsSet == true);
      _;
  }

  modifier onlyReserve() {
      require(msg.sender == reserve);
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

  modifier endBalanceNotLogged() {
      require(endBalanceLogged == false);
      _;
  }

  modifier endBalanceIsLogged() {
      require(endBalanceLogged == true);
      _;
  }

  modifier hasNotClaimed() {
      require(!hasClaimed[msg.sender]);
      _;
  }

  modifier inAdminP() {
      require(now < (start + adminP));
      _;
  }

  modifier inRaiseP() {
      require(now < (start + adminP + raiseP) && now > (start + adminP));
      _;
  }

  modifier inOpperateP() {
      require(now < (start + adminP + raiseP + opperateP) && now > (start + adminP + raiseP));
      _;
  }

  modifier inLiquidP() {
      require(now < (start + adminP + raiseP + opperateP + liquidP) && now > (start + adminP + raiseP + opperateP));
      _;
  }

  modifier inOpAndLiqP() {
      require(now < (start + adminP + raiseP + opperateP + liquidP) && now > (start + adminP + raiseP));
      _;
  }

  modifier inClaimP() {
      require(now > (start + adminP + raiseP + opperateP + liquidP));
      _;
  }
}
