// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./Rotator.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

contract ERC20Rotator is Rotator {
  using SafeERC20 for IERC20;
  IERC20 public token;

  constructor(
    IVerifier _verifier,
    IHasher _hasher,
    uint256 _denomination,
    uint32 _merkleTreeHeight,
    address _feeTo,
    uint256 _fee,
    IERC20 _token
  ) Rotator(_verifier, _hasher, _denomination, _merkleTreeHeight, _feeTo, _fee) {
    token = _token;
  }

  function _processDeposit() internal override {
    require(msg.value == 0, "ETH value is supposed to be 0 for ERC20 instance");
    token.safeTransferFrom(msg.sender, address(this), denomination);
  }

  function _processWithdraw(
    address payable _recipient
  ) internal override {

    if (fee > 0) {
      token.safeTransfer(feeTo, fee);
    }

    token.safeTransfer(_recipient, denomination - fee);
  }
}
