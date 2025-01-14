/**
 *Submitted for verification at BscScan.com on 2021-07-10
*/

/**
──────────────────────────────────────────────────────────────────────────────────────────────────────
─────────██████─██████████████─████████████───██████████████─██████████─██████████████─██████████████─
─────────██░░██─██░░░░░░░░░░██─██░░░░░░░░████─██░░░░░░░░░░██─██░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
─────────██░░██─██░░██████░░██─██░░████░░░░██─██░░██████████─████░░████─██████░░██████─██░░██████████─
─────────██░░██─██░░██──██░░██─██░░██──██░░██─██░░██───────────██░░██───────██░░██─────██░░██─────────
─────────██░░██─██░░██████░░██─██░░██──██░░██─██░░██████████───██░░██───────██░░██─────██░░██████████─
─────────██░░██─██░░░░░░░░░░██─██░░██──██░░██─██░░░░░░░░░░██───██░░██───────██░░██─────██░░░░░░░░░░██─
─██████──██░░██─██░░██████░░██─██░░██──██░░██─██░░██████████───██░░██───────██░░██─────██░░██████████─
─██░░██──██░░██─██░░██──██░░██─██░░██──██░░██─██░░██───────────██░░██───────██░░██─────██░░██─────────
─██░░██████░░██─██░░██──██░░██─██░░████░░░░██─██░░██████████─████░░████─────██░░██─────██░░██████████─
─██░░░░░░░░░░██─██░░██──██░░██─██░░░░░░░░████─██░░░░░░░░░░██─██░░░░░░██─────██░░██─────██░░░░░░░░░░██─
─██████████████─██████──██████─████████████───██████████████─██████████─────██████─────██████████████─
──────────────────────────────────────────────────────────────────────────────────────────────────────

█▀▀ █─█ █▀▀█ █▀▀ █▀▀▄ █▀▀ ─▀─ ▀█─█▀ █▀▀ 　 　 █▀▀▀ █▀▀ █▀▄▀█ █▀▀ ▀▀█▀▀ █▀▀█ █▀▄▀█ █▀▀ 
█▀▀ ▄▀▄ █──█ █▀▀ █──█ ▀▀█ ▀█▀ ─█▄█─ █▀▀ 　 　 █─▀█ █▀▀ █─▀─█ ▀▀█ ──█── █──█ █─▀─█ █▀▀ 
▀▀▀ ▀─▀ █▀▀▀ ▀▀▀ ▀──▀ ▀▀▀ ▀▀▀ ──▀── ▀▀▀ 　 　 ▀▀▀▀ ▀▀▀ ▀───▀ ▀▀▀ ──▀── ▀▀▀▀ ▀───▀ ▀▀▀

Jadeite Airdrop Claim Your Free JDT Tokens

Telegram: https://t.me/jadeitetoken
Twitter: https://twitter.com/JadeiteToken
Website: https://jadeite.site
Website: https://beryl.network
Exchange: https://gemswap.app
Launchpad: https://gemsale.app

*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

contract JadeiteAirdrop {
    
    mapping(address => bool) public Claimed;

    bool public is_active = true;
    address public token_address;
    address public owner;
    uint public airdrop_reward;
    uint public referral_reward;
    
    event AirdropClaimed(address _address, uint256 amount);
    event TokensReceived(address _sender, uint256 _amount);
    event OwnershipChanged(address _new_owner);
    
    modifier onlyOwner() {
        require(msg.sender == owner,"Not Allowed");
        _;    
    }

    constructor (address _token_address,uint256 _airdrop_reward,uint256 _referral_reward) {
        owner = msg.sender;
        token_address = _token_address;
        airdrop_reward = _airdrop_reward;
        referral_reward = _referral_reward;
    }
    
    function change_owner(address _owner) onlyOwner public {
        owner = _owner;
        emit OwnershipChanged(_owner);
    }
    
    function set_rewards(uint256 _airdrop_reward,uint256 _referral_reward) onlyOwner public {
        airdrop_reward = _airdrop_reward;
        referral_reward = _referral_reward;
    }

    function change_state() onlyOwner public {
        is_active = !is_active;
    }


    function get_balance(address token) public view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }
    

    function claim_airdrop(address referral_address) public payable {
        require(is_active,"Airdrop Distribution is paused");
        require(Claimed[msg.sender] == false, 'Airdrop already claimed!'); 
        
        IERC20 token = IERC20(token_address);
        uint256 decimal_multiplier = (10 ** token.decimals());
        uint256 _airdrop_reward = airdrop_reward * decimal_multiplier;
        uint256 _referral_reward = referral_reward * decimal_multiplier;
        uint256 reward_amount = _airdrop_reward + _referral_reward ;
        
        require(token.balanceOf(address(this)) >= reward_amount, "Insufficient Tokens in stock");
        
        Claimed[msg.sender] = true;
        token.transfer( msg.sender, _airdrop_reward);
        token.transfer( referral_address, _referral_reward);

    } 

    // global receive function
    receive() external payable {
        emit TokensReceived(msg.sender,msg.value);
    } 
    
    function withdraw_token(address token) public onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        if (balance > 0) {
            IERC20(token).transfer( msg.sender, balance);
        }
    } 
    
    fallback () external payable {}
    
}
