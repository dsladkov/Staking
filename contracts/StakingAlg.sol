// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20";

contract StakingAlg {
  IERC20 public rewardingToken;
  IERC20 public stakingToken;

  uint public rewardRate = 10; //отношение награды относительно времени застейканных токенов
  uint public lastUpdateTime;
  uint public rewardPerTokenStored;

  mapping(address => uint) public userRewardPerTokenPaid;
  mapping(address => uint) public rewards;

  mapping(address => uint) private _balances;
  uint private _totalSupply;

  modifier updateReward(address _account) {
    rewardPerTokenStored = rewardPerToken();
    lastUpdateTime = block.timestamp;
    rewards[_account] = earned(_account);
    userRewardPerTokenPaid[_account] = rewardPerTokenStored;
    _;
  }

  constructor(address _stakingToken, address _rewardsToken) {
    stakingToken = IERC20(_stakingToken);
    rewardingToken = IERC20(_rewardsToken);
  }

  function rewardPerToken() public view returns(uint) {
    if(_totalSupply == 0) {
      return 0;
    }

    return rewardPerTokenStored + (rewardRate * (block.timestamp - lastUpdateTime)) * 1e18 / _totalSupply;
  }

  function earned(address _account) public returns(uint) {
    (_balances[_account] * (rewardPerToken() - userRewardPerTokenPaid[_account]) / 1e18) + rewards[_account];
  }

  function stake(uint _amount) external updateReward(msg.sender) {
    _totalSupply += _amount;
    _balances(msg.sender) += _amount;
    stakingToken.transferFrom(msg.sender, address(this), _amount);

  }

  function withdraw(uint _amount) external updateReward(msg.sender) {
    require(_balances[msg.sender] >= _amount, "Incorrect withdraw amoun");
    unchecked {
    _totalSupply -= _amount;
    _balances(msg.sender) -= _amount;
    }
    stakingToken.transfer(msg.sender, _amount);
  }

  function getReward() external updateReward(msg.sender) {
    uint reward = rewards[msg.sender];
    rewards[msg.sender] = 0;
    rewardingToken.transfer(msg.sender, rewards);
  }
}