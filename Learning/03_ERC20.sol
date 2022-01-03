// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

/**
 * ERC20 standard token implementation.
 * Standard ERC20 token. This contract follows the implementation at https://goo.gl/mLbAPJ.
 */
contract Token {
    
  //Token name.
  string internal tokenName;

  //Token symbol.
  string internal tokenSymbol;

  //Number of decimals.
  uint8 internal tokenDecimals;

  //Total supply of tokens.
  uint256 internal tokenTotalSupply;

  //Balance information map.
  mapping (address => uint256) internal balances;

  //Token allowance mapping.
  mapping (address => mapping (address => uint256)) internal allowed;

  //Trigger when tokens are transferred, including zero value transfers.
  event Transfer(address indexed _from,address indexed _to,uint256 _value);

  //Trigger on any successful call to approve(address _spender, uint256 _value).
  event Approval(address indexed _owner,address indexed _spender,uint256 _value);
  
  constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _initialOwnerBalance) {
      tokenName = _name;
      tokenSymbol = _symbol;
      tokenDecimals = _decimals;
      tokenTotalSupply = _initialOwnerBalance;
      balances[msg.sender] = _initialOwnerBalance;
  }

  //Returns the name of the token.
  function name() external view returns (string memory _name){
    _name = tokenName;
  }

  //Returns the symbol of the token.
  function symbol() external view returns (string memory _symbol){
    _symbol = tokenSymbol;
  }

  //Returns the number of decimals the token uses.
  function decimals() external view returns (uint8 _decimals){
    _decimals = tokenDecimals;
  }

  //Returns the total token supply.
  function totalSupply()external view returns (uint256 _totalSupply){
    _totalSupply = tokenTotalSupply;
  }

  //Returns the account balance of another account with address _owner.
  function balanceOf(address _owner) external view returns (uint256 _balance){
    _balance = balances[_owner];
  }

 /* Transfers _value amount of tokens to address _to.
    The function will throw if the "from" account balance does not have enough tokens to spend.
    _to The address of the recipient, _value The amount of token to be transferred. */
  function transfer(address payable _to, uint256 _value) public returns (bool _success){
    require(balances[msg.sender] >= _value);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    _success = true;
  }

  /* Allows _spender to withdraw from your account multiple times, up to the _value amount. 
     If this function is called again it overwrites the current allowance with _value.
    _spender The address of the account able to transfer the tokens, _value The amount of tokens to be approved for transfer. */
  function approve(address _spender,uint256 _value) public returns (bool _success) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    _success = true;
  }

  /* Returns the amount which _spender is still allowed to withdraw from _owner.
    _owner The address of the account owning tokens, _spender The address of the account able to transfer the tokens. */
  function allowance(address _owner,address _spender) external view returns (uint256 _remaining){
    _remaining = allowed[_owner][_spender];
  }

  /* Transfers _value amount of tokens from address _from to address _to.
     _from The address of the sender, _to The address of the recipient,_value The amount of token to be transferred. */
  function transferFrom(address _from,address _to,uint256 _value) public returns (bool _success){
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] -= _value;
    balances[_to] += _value;
    allowed[_from][msg.sender] -= _value;

    emit Transfer(_from, _to, _value);
    _success = true;
  }

}
