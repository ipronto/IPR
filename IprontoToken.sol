pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';


contract IprontoToken is StandardToken {

  // Setting Token Name to Mango
  string public constant name = "iPRONTO";

  // Setting Token Symbol to MGO
  string public constant symbol = "IPR";

  // Setting Token Decimals to 18
  uint8 public constant decimals = 18;

  // Setting Token Decimals to 45 Million
  uint256 public constant INITIAL_SUPPLY = 45000000 * (1 ether / 1 wei);

  address public owner;

  // Flags address for KYC verrified.
  mapping (address => bool) public validKyc;

  function IprontoToken() public{
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  // Approving an address to tranfer tokens
  function approveKyc(address[] _addrs)
        public
        onlyOwner
        returns (bool)
    {
        uint len = _addrs.length;
        while (len-- > 0) {
            validKyc[_addrs[len]] = true;
        }
        return true;
    }

  function isValidKyc(address _addr) public constant returns (bool){
    return validKyc[_addr];
  }

  function approve(address _spender, uint256 _value) public returns (bool) {
    require(isValidKyc(msg.sender));
    return super.approve(_spender, _value);
  }

  function() public{
    throw;
  }
}
