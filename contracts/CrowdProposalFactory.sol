pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import './IMpoint.sol';
import './CrowdProposal.sol';

contract CrowdProposalFactory {

    /// @notice `Mpoint` token contract address
    address public immutable mpoint;
    /// @notice Mpoint protocol `GovernorAlpha` contract address
    address public immutable governor;
    /// @notice Minimum Mpoint tokens required to create a crowd proposal
    uint public immutable mpointStakeAmount;

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
    * @param mpoint_ `Mpoint` token contract address
    * @param governor_ Mpoint protocol `GovernorAlpha` contract address
    * @param mpointStakeAmount_ The minimum amount of Mpoint tokes required for creation of a crowd proposal
    */
    constructor(
        address mpoint_,
        address governor_,
        uint mpointStakeAmount_
    ) public {
        mpoint = mpoint_;
        governor = governor_;
        mpointStakeAmount = mpointStakeAmount_;
    }

    /**
    * @notice Create a new crowd proposal
    * @notice Call `Mpoint.approve(factory_address, mpointStakeAmount)` before calling this method
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
        CrowdProposal proposal = new CrowdProposal(msg.sender, targets, values, signatures, calldatas, description, mpoint, governor);
        emit CrowdProposalCreated(address(proposal), msg.sender, targets, values, signatures, calldatas, description);

        // Stake Mpoint and force proposal to delegate votes to itself
        IMpoint(mpoint).transferFrom(msg.sender, address(proposal), mpointStakeAmount);
    }
}
