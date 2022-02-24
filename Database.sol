//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.16;

import "./interface/IDB.sol";
import "./interface/IUSDT.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";


contract Database is Ownable, IDB {
    uint256 private ownerFee;
    uint256 private polkaLokrFee;
    uint256 public bridgeFee;
    uint256 private bridgeCount;
    address private recepient;
    address private adminWallet;
    IERC20 public usdtToken;


    mapping(address => mapping(address => bool)) public isFeePaid;

    event FeePaid(address depositor, uint256 amount);

    constructor(address _feeToken, address _adminWallet) {
        ownerFee = 5000000000000000000;
        polkaLokrFee = 70000000000000000000;
        bridgeFee = 3000000000;
        recepient = msg.sender;
        usdtToken = IERC20(_feeToken);
        adminWallet = _adminWallet;
    }

    function setOwnerFee(uint256 _ownerFee) public onlyOwner {
        ownerFee = _ownerFee;
        //x = _ownerFee;
    }

    function getOwnerFee() external view override returns (uint256) {
        return ownerFee;
    }

    function setPolkaLokrFee(uint256 _polkaFee) public onlyOwner {
        polkaLokrFee = _polkaFee;
    }

    function getPolkaLokrFee() external view override returns (uint256) {
        return polkaLokrFee;
    }

    function setRecepient(address _recepient) public onlyOwner {
        recepient = _recepient;
    }

    function getRecepient() external view override returns (address) {
        return recepient;
    }

    function getFeeStatus(address _tokenAddress) external view returns (bool){
        return isFeePaid[msg.sender][_tokenAddress];
    }


    function payBridgeFee(address _tokenAddress) external {
        if(bridgeCount >= 5)
        {
            address sender = msg.sender;
            usdtToken.transferFrom(sender, adminWallet, bridgeFee);
            isFeePaid[msg.sender][_tokenAddress] = true; 
            emit FeePaid(msg.sender, bridgeFee);
        }
        else
        {
             
            bridgeCount++;
        }
    }

    function setBridgeFee(uint256 _bridgeFee) public onlyOwner {
        _bridgeFee = _bridgeFee * 10**usdtToken.decimals();
        bridgeFee = _bridgeFee;
    }

    function addBridge(address bridgeContract, address bridgeOwner) external override {
        // if (bridgeID >= 5) {
        //     require(isFeePaid[bridgeID], "pay bridge fee first");
        // }
        // bridgeID++;
        emit BridgEdit(bridgeContract, bridgeOwner);
    }
}
