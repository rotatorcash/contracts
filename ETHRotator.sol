// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./Rotator.sol";

contract ETHRotator is Rotator {

  constructor(
    IVerifier _verifier,
    IHasher _hasher,
    uint256 _denomination,
    uint32 _merkleTreeHeight,
    address _feeTo,
    uint256 _fee
  ) Rotator(_verifier, _hasher, _denomination, _merkleTreeHeight, _feeTo, _fee) {}

  function _processDeposit() internal override {
    require(msg.value == denomination, "Please send `mixDenomination` ETH along with transaction");
  }

  function _processWithdraw(
    address payable _recipient
  ) internal override {
    // sanity checks
    require(msg.value == 0, "Message value is supposed to be zero for ETH instance");

    if (fee > 0) {
      (bool feeSuccess,) = feeTo.call{value: fee}("");
      require(feeSuccess, "payment to feeTo did not go thru");
    }

    (bool success,) = _recipient.call{value : denomination - fee}("");
    require(success, "payment to _recipient did not go thru");
  }
}
