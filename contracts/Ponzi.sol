pragma solidity ^0.4.18;

contract Ponzi {
  mapping (address => address) referrals;
  address private owner;
  uint private min_investment;
  bool locked;

  function Ponzi() {
    owner = msg.sender;
    referrals[owner] = owner;
    min_investment = 1;
  }

  modifier onlyCreator() {
    require(msg.sender == owner);
    _;
  }

  modifier onlyOnce() {
    require(!locked);
    locked = true;
    _;
    locked = false;
  }

  function signup(address referrer) onlyOnce payable {
    uint investment = msg.value;
    require(investment >= min_investment);
    require(referrals[referrer] != address(0));

    payout(referrals[referrer], investment);
  }

  function payout(address recipient, uint amount) private {
    while (amount > 1000) {
      recipient.transfer(amount/2);
      amount = amount/ 2;
      recipient = referrals[recipient];
      require(recipient != address(0));
      if (recipient == owner) { break; }
    }
    owner.transfer(amount);
  }

  function changeInvestment(uint amount) onlyCreator {
    min_investment = amount;
  }

  function checkReferrer(address a) constant returns(address) {
    require(referrals[a] != address(0));
    return referrals[a];
  }
}
