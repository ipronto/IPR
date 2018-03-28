pragma solidity ^0.4.18;


// CONTRACT USED TO TEST THE ICO CONTRACT
import "./IprontoToken.sol";

contract CrowdsaleiPRONTOLiveICO{
  using SafeMath for uint256;
  address public owner;

  // The token being sold
  IprontoToken public token;

  // rate for one token in wei
  uint256 public rate = 500; // 1 ether
  uint256 public discountRatePreIco = 588; // 1 ether
  uint256 public discountRateIco = 555; // 1 ether

  // funds raised in Wei
  uint256 public weiRaised;

  // Funds pool
  // Setting funds pool for PROMOTORS_POOL, PRIVATE_SALE_POOL, PRE_ICO_POOL and ICO_POOL
  uint256 public constant PROMOTORS_POOL = 18000000 * (1 ether / 1 wei);
  uint256 public constant PRIVATE_SALE_POOL = 3600000 * (1 ether / 1 wei);
  uint256 public constant PRE_ICO_POOL = 6300000 * (1 ether / 1 wei);
  uint256 public constant ICO_POOL = 17100000 * (1 ether / 1 wei);

  // Initilising tracking variables for Funds pool
  uint256 public promotorSale = 0;
  uint256 public privateSale = 0;
  uint256 public preicoSale = 0;
  uint256 public icoSale = 0;

  // Solidity event to notify the dashboard app about transfer
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  // Contract constructor
  function CrowdsaleiPRONTOLiveICO() public{
    token = createTokenContract();
    owner = msg.sender;
  }

  // Creates ERC20 standard token
  function createTokenContract() internal returns (IprontoToken) {
    return new IprontoToken();
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  // @return true if the transaction can buy tokens
  function validPurchase(uint256 weiAmount, address beneficiary) internal view returns (bool) {
    bool nonZeroPurchase = weiAmount != 0;
    bool validAddress = beneficiary != address(0);
    return nonZeroPurchase && validAddress;
  }

  // Getter function to see all funds pool balances.
  function availableTokenBalance(uint256 token_needed, uint8 mode)  internal view returns (bool){

    if (mode == 1) { // promotorSale
      return ((promotorSale + token_needed) <= PROMOTORS_POOL );
    }
    else if (mode == 2) { // Closed Group
      return ((privateSale + token_needed) <= PRIVATE_SALE_POOL);
    }
    else if (mode == 3) { // preicoSale
      return ((preicoSale + token_needed) <= PRE_ICO_POOL);
    }
    else if (mode == 4) { // icoSale
      return ((icoSale + token_needed) <= ICO_POOL);
    }
    else {
      return false;
    }
  }

  // fallback function can be used to buy tokens
  function () public payable {
    throw;
  }

  // Token transfer
  function transferToken(address beneficiary, uint256 tokens, uint8 mode) onlyOwner public {
    // Checking for valid purchase
    require(validPurchase(tokens, beneficiary));
    require(availableTokenBalance(tokens, mode));
    // Execute token purchase
    if(mode == 1){
      promotorSale = promotorSale.add(tokens);
    } else if(mode == 2) {
      privateSale = privateSale.add(tokens);
    } else if(mode == 3) {
      preicoSale = preicoSale.add(tokens);
    } else if(mode == 4) {
      icoSale = icoSale.add(tokens);
    } else {
      throw;
    }
    token.transfer(beneficiary, tokens);
    TokenPurchase(beneficiary, beneficiary, tokens, tokens);
  }

  // Function to get balance of an address
  function balanceOf(address _addr) public view returns (uint256 balance) {
    return token.balanceOf(_addr);
  }

  function setTokenPrice(uint256 _rate,uint256 _discountRatePreIco,uint256 _discountRateIco) onlyOwner public returns (bool){
    rate = _rate; // 1 ether
    discountRatePreIco = _discountRatePreIco; // 1 ether
    discountRateIco = _discountRateIco; // 1 ether
    return true;
  }
}
