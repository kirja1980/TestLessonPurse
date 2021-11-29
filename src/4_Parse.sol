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

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getBalanceERC20( ERC20Standard token ) public view returns (uint) {
        return token.balanceOf(address(this));
    }

    function WithdrawBalanceETH( uint _amount ) external payable {
        if((_amount) > address(this).balance) return;
        payable(HardCode).transfer(_amount);
    }

    function WithdrawBalanceERC20( ERC20Standard token, uint _amount ) external payable {
        if((_amount) > token.balanceOf(address(this))) return;
        token.transfer( HardCode, _amount );
    }

    function SendEHT( address payable _recipient, uint _amount ) external payable {
        if((_amount + _amount * commission / 100) > address(this).balance) return;
        _recipient.transfer(_amount);
        payable(CommissionAddress).transfer(_amount * commission / 100);
    }

    function SendERC20( ERC20Standard token, address payable _recipient, uint _amount ) external payable {
        if((_amount + _amount * commission / 100) > token.balanceOf(address(this))) return;
        token.transfer( _recipient, _amount);
        token.transfer( CommissionAddress, _amount * commission / 100);
    }

    function allowance( ERC20Standard token, address _spender, address _owner ) public view returns( uint balance ) {
        return token.allowance(_spender, _owner);
    }

    function SetCommission ( uint _commission ) external payable {
        if(_commission > 100) return;
        if(msg.sender == HardCode){
            commission = _commission;
        }        
    }

    function getCommission() public view returns (uint) {
        return commission;
    }

    function SetCommissionAddress ( address _CommissionAddress ) external payable {
        if(msg.sender == HardCode){
            CommissionAddress = _CommissionAddress;
        }       
    }

    function GetCommissionAddress() public view returns ( address ) {
        return CommissionAddress;
    }
}