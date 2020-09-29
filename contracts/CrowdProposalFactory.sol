pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import './IMafi.sol';
import './CrowdProposal.sol';

contract CrowdProposalFactory {

    /// @notice `MAFI` token contract address
    address public immutable mafi;
    /// @notice Mafi protocol `GovernorAlpha` contract address
    address public immutable governor;
    /// @notice Minimum MAFI tokens required to create a crowd proposal
    uint public immutable mafiStakeAmount;

    /// @notice An event emitted when a crowd proposal is created
    event CrowdProposalCreated (
        address indexed proposal,
        address indexed author,
        address[] targets,
        uint[] values,
        string[] signatures,
        bytes[] calldatas,
        string description
    );

    /**
    * @notice Construct a proposal factory for crowd proposals
    * @param mafi_ `MAFI` token contract address
    * @param governor_ Mafi protocol `GovernorAlpha` contract address
    * @param mafiStakeAmount_ The minimum amount of MAFI tokes required for creation of a crowd proposal
    */
    constructor(
        address mafi_,
        address governor_,
        uint mafiStakeAmount_
    ) public {
        mafi = mafi_;
        governor = governor_;
        mafiStakeAmount = mafiStakeAmount_;
    }

    /**
    * @notice Create a new crowd proposal
    * @notice Call `Mafi.approve(factory_address, mafiStakeAmount)` before calling this method
    * @param targets The ordered list of target addresses for calls to be made
    * @param values The ordered list of values (i.e. msg.value) to be passed to the calls to be made
    * @param signatures The ordered list of function signatures to be called
    * @param calldatas The ordered list of calldata to be passed to each call
    * @param description The block at which voting begins: holders must delegate their votes prior to this block
    */
    function createCrowdProposal(
        address[] memory targets,
        uint[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) external {
        CrowdProposal proposal = new CrowdProposal(msg.sender, targets, values, signatures, calldatas, description, mafi, governor);
        emit CrowdProposalCreated(address(proposal), msg.sender, targets, values, signatures, calldatas, description);

        // Stake MAFI and force proposal to delegate votes to itself
        IMafi(mafi).transferFrom(msg.sender, address(proposal), mafiStakeAmount);
    }
}
