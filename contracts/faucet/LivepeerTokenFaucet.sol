pragma solidity ^0.4.13;

import "../LivepeerToken.sol";

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

/*
 * @title Facuet for the Livepeer Token
 */
contract LivepeerTokenFaucet is Ownable {
    // Token
    LivepeerToken public token;

    // Amount of token sent to sender for a request
    uint256 public requestAmount;

    // Amount of time a sender must wait between requests
    uint256 public requestWait;

    // sender => timestamp at which sender can make another request
    mapping (address => uint256) public nextValidRequest;

    // Whitelist addresses that can bypass faucet request rate limit
    mapping (address => bool) public isWhitelisted;

    // Checks if a request is valid (sender is whitelisted or has waited the rate limit time)
    modifier validRequest() {
        require(isWhitelisted[msg.sender] || block.timestamp >= nextValidRequest[msg.sender]);
        _;
    }

    event Request(address indexed to, uint256 amount);

    /*
     * @dev LivepeerTokenFacuet constructor
     * @param _token Address of LivepeerToken
     * @param _requestAmount Amount of token sent to sender for a request
     * @param _requestWait Amount of time a sender must wait between request (denominated in hours)
     */
    function LivepeerTokenFaucet(address _token, uint256 _requestAmount, uint256 _requestWait) {
        token = LivepeerToken(_token);
        requestAmount = _requestAmount;
        requestWait = _requestWait;
    }

    /*
     * @dev Add an address to the whitelist
     * @param _addr Address to be whitelisted
     */
    function addToWhitelist(address _addr) external onlyOwner returns (bool) {
        isWhitelisted[_addr] = true;

        return true;
    }

    /*
     * @dev Remove an address from the whitelist
     * @param _addr Address to be removed from whitelist
     */
    function removeFromWhitelist(address _addr) external onlyOwner returns (bool) {
        isWhitelisted[_addr] = false;

        return true;
    }

    /*
     * @dev Request an amount of token to be sent to sender
     */
    function request() external validRequest returns (bool) {
        if (!isWhitelisted[msg.sender]) {
            nextValidRequest[msg.sender] = block.timestamp + requestWait * 1 hours;
        }

        token.transfer(msg.sender, requestAmount);

        Request(msg.sender, requestAmount);

        return true;
    }
}
