pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/Math.sol";


/**
 * @title License Token
 * @author Alberto Cuesta Canada
 * @notice Implements an ERC721 license token with validity by top up.
 */
contract LicenseToken is ERC721, Ownable {

    event TopUp(uint256 licenseId, uint256 expiry);

    address paymentsToken;

    /**
     * @notice mapping from token id to expiry date (in unix time)
     */
    mapping(uint256 => uint256) internal expiry;

    /**
     * @notice The constructor for the License Token.
     */
    constructor(address _paymentsToken)
        public
    {
        paymentsToken = _paymentsToken;
    }

    /**
     * @notice Increase the expiry time of a license by one second per wei.
     * @param _licenseId The license id.
     */
    function topUp(uint256 _licenseId)
        external
        payable
    {
        uint256 timeToAdd = msg.value;
        expiry[_licenseId] = Math.max(now, expiry[_licenseId]) + timeToAdd;
        emit TopUp(_licenseId, expiry[_licenseId]);
    }

    /**
     * @notice Mint new licenses, only owner.
     * @param _to The address to receive the license.
     * @param _licenseId The unique license id.
     */
    function mint(address _to, uint256 _licenseId)
        public
        onlyOwner()
    {
        _mint(_to, _licenseId);
    }

    /**
     * @notice Retrieve an expiry date for a license
     * @param _licenseId The license id.
     */
    function getExpiry(uint256 _licenseId)
        public
        view
        returns(uint256)
    {
        return expiry[_licenseId];
    }
}
