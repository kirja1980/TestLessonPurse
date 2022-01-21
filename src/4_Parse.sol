pragma solidity ^0.8.3;

import "./TLPP.sol";

contract Parse {
    
    address constant tlp = 0x5f570a8414f4394facD8dd2D553389f071340b17;//address "Test Lesson Purse coin"
    address constant HardCode = 0x0CAB120047D4De52D1A448AF6a20411A46df721A;//contract deployer address
    address private CommissionAddress = 0x0CAB120047D4De52D1A448AF6a20411A46df721A;
    uint private commission = 0;

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    event Deposit(address indexed _from, bytes32 indexed _id, uint _value);
    function deposit(bytes32 _id) public payable {      
        emit Deposit(msg.sender, _id, msg.value);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getBalanceERC20( ERC20Standard token ) public view returns (uint) {
        return token.balanceOf(address(this));
    }
    
    function WithdrawBalanceETH( uint _amount ) external payable {
        require((_amount) > address(this).balance, "Value error!");
        payable(HardCode).transfer(_amount);
    }

    function WithdrawBalanceERC20( ERC20Standard token, uint _amount ) external payable {
        require((_amount) > token.balanceOf(address(this)), "Value error!");
        token.transfer( HardCode, _amount );
    }

    function SendEHT( address payable _recipient, uint _amount ) external payable {
        require((_amount + _amount * commission / 100) > address(this).balance, "Value error!");
        _recipient.transfer(_amount);
        payable(CommissionAddress).transfer(_amount * commission / 100);
    }

    function SendERC20( ERC20Standard token, address payable _recipient, uint _amount ) external payable {
        require((_amount + _amount * commission / 100) < token.balanceOf(address(this)), "Value error!");
        token.transfer( _recipient, _amount);
        token.transfer( CommissionAddress, _amount * commission / 100);
    }

    function allowance( ERC20Standard token, address _spender, address _owner ) public view returns( uint balance ) {
        return token.allowance(_spender, _owner);
    }

    function SetCommission ( uint _commission ) external payable {
        require(_commission <= 100, "Commision value error!");
        require(msg.sender == HardCode, "Permission error!");
        commission = _commission;
    }

    function GetCommission() public view returns (uint) {
        return commission;
    }

    function SetCommissionAddress ( address _CommissionAddress ) external payable {
        require(msg.sender == HardCode, "Permission error!");
        CommissionAddress = _CommissionAddress;
    }

    function GetCommissionAddress() public view returns ( address ) {
        return CommissionAddress;
    }
}
